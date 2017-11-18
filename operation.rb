module Analytics
  class Operation

    UUID_REGEXP = /[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}/
    SIMPLIFIABLE_REGEX = /#{UUID_REGEXP}|\+|-|\(|\)/

    def self.simplify(operation)
      return operation unless operation.gsub(SIMPLIFIABLE_REGEX, '').empty?
      Analytics::Operation.remove_duplicates(Analytics::Operation.remove_parenthesis(operation))
    end

    def self.remove_duplicates(operation)
      operation.scan(UUID_REGEXP).each do |uuid|
        while operation.index(uuid) == 0 && operation.index("-#{uuid}")
          operation = operation.sub(uuid, '').sub("-#{uuid}", '')
        end
        while operation.index("+#{uuid}") && operation.index("-#{uuid}")
          operation = operation.sub("+#{uuid}", '').sub("-#{uuid}", '')
        end
      end

      if operation.chars.first == '+'
        operation = operation[1..-1]
      end

      operation
    end

    def self.remove_parenthesis(operation)
      while operation.index('(') == 0 || operation.index('+(') || operation.index('-(')
        new_operation = ''
        count = 0
        detected = false
        if operation.index('(') == 0
          operation.scan(SIMPLIFIABLE_REGEX).each_with_index do |member, index|
            count += 1 if index == 0 || member == '('
            next if index == 0
            if member == ')'
              count -= 1
              if count == 0 && !detected
                detected = true
                next
              end
            end
            new_operation += member
          end
        elsif operation.index('+(')
          aux = operation.split('+(', 2)
          new_operation += aux[0]
          new_operation += '+'
          count = 1
          aux[1].scan(SIMPLIFIABLE_REGEX).each do |member|
            if member == ')'
              count -= 1
              if count == 0 && !detected
                detected = true
                next
              end
            elsif member == '('
              count += 1
            end
            new_operation += member
          end
        elsif operation.index('-(')
          aux = operation.split('-(', 2)
          new_operation += aux[0]
          new_operation += '-'
          count = 1
          aux[1].scan(SIMPLIFIABLE_REGEX).each do |member|
            if member == ')'
              count -= 1
              if count == 0
                detected = true
                next
              end
            elsif member == '('
              count += 1
            end
            if count == 1 && !detected
              if member == '-'
                member = '+'
              elsif member == '+'
                member = '-'
              end
            end
            new_operation += member
          end
        end
        operation = new_operation
      end
      operation
    end

  end
end

Analytics::Operation.simplify "(4f2764b0-0d0b-0133-d88f-7672e03e9ad0)+(5849fb30-0d0b-0133-d891-7672e03e9ad0)"

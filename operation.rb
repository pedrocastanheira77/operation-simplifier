module Analytics
  class Operation

    UUID_REGEXP = /[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}/
    SIMPLIFIABLE_REGEX = /#{UUID_REGEXP}|\+|-|\(|\)/

    def simplify(operation)
      return operation unless operation.gsub(SIMPLIFIABLE_REGEX, '').empty?
      operation_without_parenthesis = self.remove_parenthesis(operation)
      self.remove_duplicates(operation_without_parenthesis)
    end

    def remove_duplicates(operation)
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

    def remove_parenthesis(operation)
      while operation.index('(') == 0 || operation.index('+(') || operation.index('-(')
        new_operation = ''
        @match = 0 # matches when is equal to zero
        @detected = false
        if operation.index('(') == 0
          new_operation = remove_when_starts_with_parenthesis(operation, new_operation)
        elsif operation.index('+(')
          new_operation = remove_when_has_plus_and_paranthesis(operation, new_operation)
        elsif operation.index('-(')
          new_operation = remove_when_has_minus_and_paranthesis(operation, new_operation)
        end
        operation = new_operation
      end
      operation
    end

    def remove_when_starts_with_parenthesis(operation, new_operation)
      result = new_operation
      operation.scan(SIMPLIFIABLE_REGEX).each_with_index do |member, index|
        @match += 1 if index == 0 || member == '('
        next if index == 0
        if member == ')'
          @match -= 1
          if match? && !@detected
            @detected = true
            next
          end
        end
        result += member
      end
      result
    end

    def remove_when_has_plus_and_paranthesis(operation, new_operation)
      result = new_operation
      aux = operation.split('+(', 2)
      result += aux[0]
      result += (aux[1][0]=="-") ? '' : '+'
      @match = 1
      aux[1].scan(SIMPLIFIABLE_REGEX).each do |member|
        if member == ')'
          @match -= 1
          if match? && !@detected
            @detected = true
            next
          end
        elsif member == '('
          @match += 1
        end
        result += member
      end
      result
    end

    def remove_when_has_minus_and_paranthesis(operation, new_operation)
      result = new_operation
      aux = operation.split('-(', 2)
      result += aux[0]
      if (aux[1][0]=="-")
        result += '+'
        aux[1] = aux[1][1..-1]
      elsif (aux[1][0]=="+")
        result += '-'
        aux[1] = aux[1][1..-1]
      else
        result += '-'
      end
      @match = 1
      aux[1].scan(SIMPLIFIABLE_REGEX).each do |member|
        if member == ')'
          @match -= 1
          if match?
            @detected = true
            next
          end
        elsif member == '('
          @match += 1
        end
        if @match == 1 && !@detected
          if member == '-'
            member = '+'
          elsif member == '+'
            member = '-'
          end
        end
        result += member
      end
      result
    end

    def match?
      @match == 0
    end

  end
end

@a = "4f2764b0-0d0b-0133-d88f-7672e03e9ad0"
@b = "5849fb30-0d0b-0133-d891-7672e03e9ad0"
operation = "(#{@a})-((#{@b}))"
p Analytics::Operation.new.remove_parenthesis operation

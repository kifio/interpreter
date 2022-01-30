INTEGER, PLUS, MINUS, EOF = 'INTEGER', 'PLUS', 'MINUS', 'EOF'

class Token(object):
    
    def __init__(self, type, value):
        self.type = type
        self.value = value

    def __str__(self):
        return 'Token({type}, {value})'.format(
            type = self.type,
            value = repr(self.value)
        )

    def __repr__(self):
        return self.__str__()

    def append(self, value, type):
        if type == INTEGER:
            self.value += int(value)

class Interpreter(object):

    def __init__(self, text):
        self.text = text.strip()
        self.pos = 0
        self.current_token = None

    def error(self):
        raise Exception('Error parsing input')

    def get_next_toekn(self):
        text = self.text

        if self.pos > len(text) - 1:
            return Token(EOF, None)

        current_char = text[self.pos]

        while current_char == ' ':
            self.pos += 1
            current_char = text[self.pos]

        if current_char.isdigit():
            number = ''
            dec = 0
            while self.pos <= len(text) - 1 and current_char.isdigit():

                number += current_char

                self.pos += 1

                if self.pos > len(text) - 1:
                    break

                dec += 1
                current_char = text[self.pos]
            
            token = Token(INTEGER, int(number))
            return token

        if current_char == '+':
            token = Token(PLUS, current_char)
            self.pos += 1
            return token   

        if current_char == '-':
            token = Token(MINUS, current_char)
            self.pos += 1
            return token  

        self.error()

    def eat(self, token_type):
        if self.current_token.type == token_type:
            self.current_token = self.get_next_toekn()
        else:
            self.error()

    def expr(self):
        self.current_token = self.get_next_toekn()

        left = self.current_token
        self.eat(INTEGER)

        op = self.current_token
        
        if op.type == PLUS:
            self.eat(PLUS)
        else:
            self.eat(MINUS)

        right = self.current_token
        self.eat(INTEGER)


        if op.type == PLUS:
            result = left.value + right.value
        else:
            result = left.value - right.value

        return result

def main():
    while True:
        try:
            text = input('calc> ')
        except EOFError:
            break
        if not text:
            continue       

        interpreter = Interpreter(text)
        result = interpreter.expr()
        print(result)

if __name__ == '__main__':
    main()
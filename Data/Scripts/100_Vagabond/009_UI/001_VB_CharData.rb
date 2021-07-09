def charWidth(char,font)
  if char == ' '
    return 4 if font=="Small" || font=="Smallest"
    return 6
  end
  rects = charRects(char,font)
  max = 0
  for r in rects
    width = r[0]+r[2]
    max = width if max < width
  end
  return max * 2 + 2
end

def charRects(char,font)
  if font=="Small"
    return charRectsSmall(char)
  elsif font=="Smallest"
    return charRectsSmallest(char)
  end
  case char
  # List of [x,y,w,h]
  when 'A'
    return [[0,4,1,8],
            [1,3,3,1],
            [1,8,3,1],
            [4,4,1,8]]
  when 'a'
    return [[4,7,1,5],
            [1,6,3,1],
            [1,8,3,1],
            [1,11,3,1],
            [0,9,1,2]]
  when 'B'
    return [[0,3,1,9],
            [1,3,3,1],
            [1,7,3,1],
            [1,11,3,1],
            [4,4,1,3],
            [4,8,1,3]]
  when 'b'
    return [[0,3,1,9],
            [1,6,3,1],
            [1,11,3,1],
            [4,7,1,4]]
  when 'C'
    return [[0,4,1,7],
            [1,3,3,1],
            [1,11,3,1],
            [4,4,1,1],
            [4,10,1,1]]
  when 'c'
    return [[0,7,1,4],
            [1,6,3,1],
            [1,11,3,1],
            [4,7,1,1],
            [4,10,1,1]]
  when 'D'
    return [[0,3,1,9],
            [1,3,3,1],
            [1,11,3,1],
            [4,4,1,7]]
  when 'd'
    return [[4,3,1,9],
            [1,6,3,1],
            [1,11,3,1],
            [0,7,1,4]]
  when 'E'
    return [[0,3,1,9],
            [1,3,4,1],
            [1,7,3,1],
            [1,11,4,1]]
  when 'e'
    return [[0,7,1,4],
            [1,6,3,1],
            [1,11,3,1],
            [4,7,1,1],
            [4,10,1,1],
            [1,8,4,1]]
  when 'é'
    return [[0,7,1,4],
            [1,6,3,1],
            [1,11,3,1],
            [4,7,1,1],
            [4,10,1,1],
            [1,8,4,1],
            [1,4,1,1],
            [2,3,2,1]]
  when 'F'
    return [[0,3,1,9],
            [1,3,4,1],
            [1,7,3,1]]
  when 'f'
    return [[2,4,1,8],
            [3,3,2,1],
            [0,6,5,1]]
  when 'G'
    return [[0,4,1,7],
            [1,3,3,1],
            [1,11,3,1],
            [4,4,1,1],
            [4,8,1,3],
            [3,8,1,1]]
  when 'g'
    return [[0,7,1,3],
            [1,6,3,1],
            [1,10,3,1],
            [4,7,1,6],
            [1,13,3,1],
            [0,12,1,1]]
  when 'H'
    return [[0,3,1,9],
            [4,3,1,9],
            [1,7,3,1]]
  when 'h'
    return [[0,3,1,9],
            [4,7,1,5],
            [1,6,3,1]]
  when 'I'
    return [[0,3,5,1],
            [0,11,5,1],
            [2,4,1,7]]
  when 'i'
    return [[1,3,1,1],
            [1,6,1,6]]
  when 'ï'
    return [[0,3,1,1],
            [2,3,1,1],
            [1,6,1,6]]
  when 'J'
    return [[1,11,3,1],
            [4,3,1,8],
            [0,10,1,1]]
  when 'j'
    return [[3,3,1,1],
            [3,6,1,7],
            [0,12,1,1],
            [1,13,2,1]]
  when 'K'
    return [[0,3,1,9],
            [1,6,1,3],
            [2,5,1,1],
            [3,4,1,1],
            [4,3,1,1],
            [2,9,1,1],
            [3,10,1,1],
            [4,11,1,1]]
  when 'k'
    return [[0,3,1,9],
            [1,9,2,1],
            [2,8,1,1],
            [3,7,1,1],
            [4,6,1,1],
            [3,10,1,1],
            [4,11,1,1]]
  when 'L'
    return [[0,3,1,9],
            [1,11,4,1]]
  when 'l'
    return [[1,3,1,9]]
  when 'M'
    return [[0,3,1,9],
            [4,3,1,9],
            [1,4,1,2],
            [3,4,1,2],
            [2,6,1,2]]
  when 'm'
    return [[0,6,4,1],
            [0,7,1,5],
            [2,7,1,5],
            [4,7,1,5]]
  when 'N'
    return [[0,3,1,9],
            [4,3,1,9],
            [1,4,1,2],
            [2,6,1,2],
            [3,8,1,2]]
  when 'n'
    return [[0,6,4,1],
            [0,7,1,5],
            [4,7,1,5]]
  when 'O'
    return [[0,4,1,7],
            [1,3,3,1],
            [1,11,3,1],
            [4,4,1,7]]
  when 'o'
    return [[1,6,3,1],
            [1,11,3,1],
            [0,7,1,4],
            [4,7,1,4]]
  when 'P'
    return [[0,3,1,9],
            [1,3,3,1],
            [4,4,1,4],
            [1,8,3,1]]
  when 'p'
    return [[0,6,1,8],
            [1,6,3,1],
            [1,10,3,1],
            [4,7,1,3]]
  when 'Q'
    return [[0,4,1,7],
            [1,3,3,1],
            [1,11,3,1],
            [4,4,1,7],
            [2,9,1,1],
            [3,10,1,1],
            [5,11,1,1]]
  when 'q'
    return [[4,6,1,8],
            [1,6,3,1],
            [1,10,3,1],
            [0,7,1,3]]
  when 'R'
    return [[0,3,1,9],
            [1,3,3,1],
            [4,4,1,4],
            [1,8,3,1],
            [2,9,1,1],
            [3,10,1,1],
            [4,11,1,1]]
  when 'r'
    return [[0,6,1,6],
            [1,7,1,1],
            [2,6,2,1]]
  when 'S'
    return [[0,4,1,3],
            [1,3,3,1],
            [1,7,3,1],
            [1,11,3,1],
            [4,8,1,3],
            [0,10,1,1],
            [4,4,1,1]]
  when 's'
    return [[0,7,1,1],
            [1,6,3,1],
            [1,8,1,1],
            [2,9,2,1],
            [1,11,3,1],
            [4,10,1,1],
            [0,10,1,1],
            [4,7,1,1]]
  when 'T'
    return [[0,3,5,1],
            [2,4,1,8]]
  when 't'
    return [[2,4,1,7],
            [3,11,2,1],
            [0,6,5,1]]
  when 'U'
    return [[0,3,1,8],
            [4,3,1,8],
            [1,11,3,1]]
  when 'u'
    return [[0,6,1,5],
            [4,6,1,6],
            [1,11,3,1]]
  when 'V'
    return [[0,3,1,5],
            [4,3,1,5],
            [1,8,1,2],
            [3,8,1,2],
            [2,10,1,2]]
  when 'v'
    return [[0,6,1,3],
            [4,6,1,3],
            [1,9,1,2],
            [3,9,1,2],
            [2,11,1,1]]
  when 'W'
    return [[0,3,1,9],
            [4,3,1,9],
            [1,9,1,2],
            [3,9,1,2],
            [2,7,1,2]]
  when 'w'
    return [[0,6,1,5],
            [4,6,1,5],
            [1,11,1,1],
            [3,11,1,1],
            [2,6,1,5]]
  when 'X'
    return [[0,3,1,2],
            [4,3,1,2],
            [1,5,1,2],
            [3,5,1,2],
            [2,7,1,1],
            [0,10,1,2],
            [4,10,1,2],
            [1,8,1,2],
            [3,8,1,2]]
  when 'x'
    return [[0,6,1,1],
            [4,6,1,1],
            [1,7,1,1],
            [3,7,1,1],
            [2,8,1,2],
            [0,11,1,1],
            [4,11,1,1],
            [1,10,1,1],
            [3,10,1,1]]
  when 'Y'
    return [[0,3,1,3],
            [4,3,1,3],
            [1,6,1,2],
            [3,6,1,2],
            [2,8,1,4]]
  when 'y'
    return [[0,6,1,4],
            [1,10,3,1],
            [4,6,1,7],
            [1,13,3,1],
            [0,12,1,1]]
  when 'Z'
    return [[0,3,4,1],
            [4,3,1,2],
            [3,5,1,2],
            [2,7,1,1],
            [0,10,1,2],
            [1,11,4,1],
            [1,8,1,2]]
  when 'z'
    return [[0,6,5,1],
            [3,7,1,1],
            [2,8,1,1],
            [1,9,1,1],
            [0,11,5,1],
            [0,10,1,1]]
  when '.'
    return [[0,10,2,2]]
  when ','
    return [[0,10,2,2],
            [1,12,1,1],
            [0,13,1,1]]
  when '!'
    return [[1,2,1,7],
            [1,11,1,1]]
  when '?'
    return [[1,2,3,1],
            [0,3,1,2],
            [4,3,1,3],
            [3,6,1,1],
            [2,7,1,2],
            [2,11,1,1]]
  when "'"
    return [[0,2,2,2],
            [1,4,1,1],
            [0,5,1,1]]
  when '"'
    return [[0,2,1,3],
            [2,2,1,3]]
  when '-'
    return [[0,7,5,1]]
  when '1'
    return [[1,3,1,1],
            [2,3,1,8],
            [1,11,3,1]]
  when '2'
    return [[0,4,1,1],
            [1,3,3,1],
            [4,4,1,3],
            [3,7,1,1],
            [2,8,1,1],
            [1,9,1,1],
            [0,10,1,1],
            [0,11,5,1]]
  when '3'
    return [[0,4,1,1],
            [1,3,3,1],
            [4,4,1,3],
            [2,7,2,1],
            [4,8,1,3],
            [1,11,3,1],
            [0,10,1,1]]
  when '4'
    return [[0,5,1,5],
            [1,4,1,1],
            [2,3,2,1],
            [3,4,1,8],
            [1,9,4,1]]
  when '5'
    return [[0,3,5,1],
            [0,4,1,4],
            [1,7,3,1],
            [4,8,1,3],
            [0,11,4,1]]
  when '6'
    return [[1,3,3,1],
            [0,4,1,7],
            [1,7,3,1],
            [4,8,1,3],
            [1,11,3,1],
            [4,4,1,1]]
  when '7'
    return [[0,3,5,1],
            [4,4,1,3],
            [3,7,1,3],
            [2,10,1,2]]
  when '8'
    return [[1,3,3,1],
            [0,4,1,3],
            [1,7,3,1],
            [4,8,1,3],
            [1,11,3,1],
            [4,4,1,3],
            [0,8,1,3]]
  when '9'
    return [[1,3,3,1],
            [0,4,1,3],
            [1,7,3,1],
            [1,11,3,1],
            [4,4,1,7],
            [0,10,1,1]]
  when '0'
    return [[0,4,1,7],
            [1,3,3,1],
            [1,11,3,1],
            [4,4,1,7]]
  when ':'
    return [[0,5,2,2],
            [0,9,2,2]]
  when ';'
    return [[0,5,2,2],
            [0,9,2,2],
            [1,11,1,1],
            [0,12,1,1]]
  when '_'
    return [[0,11,5,1]]
  when '+'
    return [[0,7,5,1],
            [2,5,1,5]]
  when '='
    return [[0,6,5,1],
            [0,9,5,1]]
  when '~'
    return [[0,7,1,1],
            [1,6,2,1],
            [3,7,2,1],
            [5,6,1,1]]
  when '('
    return [[1,2,1,1],
            [0,3,1,10],
            [1,13,1,1]]
  when ')'
    return [[1,2,1,1],
            [2,3,1,10],
            [1,13,1,1]]
  when '['
    return [[1,2,1,1],
            [0,2,1,12],
            [1,13,1,1]]
  when ']'
    return [[1,2,1,1],
            [2,2,1,12],
            [1,13,1,1]]
  when '/'
    return [[0,10,1,2],
            [1,8,1,2],
            [2,6,1,2],
            [3,4,1,2],
            [4,2,1,2]]
  when '\\'
    return [[4,10,1,2],
            [3,8,1,2],
            [2,6,1,2],
            [1,4,1,2],
            [0,2,1,2]]
  when '&'
    return [[2,3,1,1],
            [1,4,1,2],
            [3,4,1,2],
            [2,6,1,2],
            [4,7,1,1],
            [1,8,1,1],
            [0,9,1,2],
            [3,8,1,3],
            [1,11,2,1],
            [4,11,1,1]]
  when '%'
    return [[0,10,1,2],
            [1,8,1,2],
            [2,6,1,2],
            [3,4,1,2],
            [4,2,1,2],
            [0,2,3,1],
            [0,3,1,3],
            [2,3,1,2],
            [0,5,2,1],
            [2,9,1,2],
            [3,8,1,1],
            [4,8,1,4],
            [2,11,2,1]]
  when '$'
    return [[1,2,1,10],
            [2,2,2,1],
            [2,6,2,1],
            [4,3,1,3],
            [0,8,4,1],
            [0,10,4,1]]
  when '@'
    return [[2,3,4,1],
            [1,4,1,1],
            [6,4,1,1],
            [0,5,1,5],
            [7,5,1,4],
            [3,5,3,1],
            [2,6,1,3],
            [5,6,1,3],
            [3,9,1,1],
            [5,9,2,1],
            [1,10,1,1],
            [2,11,6,1]]
  when '<'
    return [[4,2,1,1],
            [3,3,1,1],
            [2,4,1,1],
            [1,5,1,1],
            [0,6,1,2],
            [1,8,1,1],
            [2,9,1,1],
            [3,10,1,1],
            [4,11,1,1]]
  when '>'
    return [[0,2,1,1],
            [1,3,1,1],
            [2,4,1,1],
            [3,5,1,1],
            [4,6,1,2],
            [3,8,1,1],
            [2,9,1,1],
            [1,10,1,1],
            [0,11,1,1]]
  when '*'
    return [[0,5,1,1],
            [2,5,1,1],
            [4,5,1,1],
            [1,6,3,1],
            [0,7,5,1],
            [1,8,3,1],
            [0,9,1,1],
            [2,9,1,1],
            [4,9,1,1]]
  when '|'
    return [[1,2,1,11]]
  when '§'
    return [[1,9,4,2],
            [2,8,2,1],
            [2,11,2,1],
            [4,3,1,6],
            [5,4,1,2],
            [6,5,1,2],
            [7,7,1,2],
            [6,9,1,1]]
  when '#'
    return [[3,3,1,2],
            [6,3,1,2],
            [1,5,7,1],
            [2,6,1,3],
            [5,6,1,3],
            [0,9,7,1],
            [1,10,1,2],
            [4,10,1,2]]
  when '♂'
    return [[2,2,1,5],
            [1,3,3,1],
            [0,4,1,1],
            [4,4,1,1],
            [1,7,3,1],
            [0,8,1,3],
            [4,8,1,3],
            [1,11,3,1]]
  when '♀'
    return [[1,2,3,1],
            [0,3,1,3],
            [4,3,1,3],
            [1,6,3,1],
            [0,8,5,1],
            [2,7,1,5]]
  end
  return [[0,3,1,9],
          [1,3,3,1],
          [1,11,3,1],
          [4,3,1,9]]
end
        
def charRectsSmall(char)
  case char
  # List of [x,y,w,h]
  when 'A'
    return [[1,3,2,1],
            [0,4,1,6],
            [3,4,1,6],
            [1,6,2,1]]
  when 'a'
    return [[1,5,3,1],
            [0,6,1,3],
            [1,9,1,1],
            [2,8,1,1],
            [3,6,1,4]]
  when 'B'
    return [[0,3,1,7],
            [1,3,2,1],
            [1,6,2,1],
            [1,9,2,1],
            [3,4,1,2],
            [3,7,1,2]]
  when 'b'
    return [[0,3,1,7],
            [1,5,2,1],
            [1,9,2,1],
            [3,6,1,3]]
  when 'C'
    return [[1,3,2,1],
            [0,4,1,5],
            [1,9,2,1],
            [3,4,1,1],
            [3,8,1,1]]
  when 'c'
    return [[1,5,2,1],
            [0,6,1,3],
            [1,9,2,1],
            [3,6,1,1],
            [3,8,1,1]]
  when 'D'
    return [[0,3,1,7],
            [1,3,2,1],
            [1,9,2,1],
            [3,4,1,5]]
  when 'd'
    return [[3,3,1,7],
            [1,5,2,1],
            [1,9,2,1],
            [0,6,1,3]]
  when 'E'
    return [[0,3,1,7],
            [1,3,3,1],
            [1,9,3,1],
            [1,6,2,1]]
  when 'e'
    return [[1,5,2,1],
            [0,6,1,3],
            [1,9,3,1],
            [3,6,1,1],
            [1,7,3,1]]
  when 'é'
    return [[1,5,2,1],
            [0,6,1,3],
            [1,9,3,1],
            [3,6,1,1],
            [1,7,3,1],
            [1,3,2,1]]
  when 'F'
    return [[0,3,1,7],
            [1,3,3,1],
            [1,6,2,1]]
  when 'f'
    return [[1,4,1,6],
            [2,3,2,1],
            [0,5,3,1]]
  when 'G'
    return [[1,3,2,1],
            [0,4,1,5],
            [1,9,2,1],
            [3,4,1,1],
            [3,6,1,3],
            [2,6,1,1]]
  when 'g'
    return [[3,5,1,5],
            [1,5,2,1],
            [1,8,2,1],
            [0,6,1,2],
            [1,10,2,1]]
  when 'H'
    return [[0,3,1,7],
            [3,3,1,7],
            [1,6,2,1]]
  when 'h'
    return [[0,3,1,7],
            [3,6,1,4],
            [1,5,2,1]]
  when 'I'
    return [[1,3,1,7],
            [0,3,3,1],
            [0,9,3,1]]
  when 'i'
    return [[1,3,1,1],
            [1,5,1,5]]
  when 'ï'
    return [[0,3,1,1],
            [2,3,1,1],
            [1,5,1,5]]
  when 'J'
    return [[0,7,1,2],
            [1,9,2,1],
            [3,3,1,6]]
  when 'j'
    return [[2,3,1,1],
            [2,5,1,4],
            [0,9,2,1]]
  when 'K'
    return [[0,3,1,7],
            [1,6,1,1],
            [2,5,1,1],
            [2,7,1,1],
            [3,3,1,2],
            [3,8,1,2]]
  when 'k'
    return [[0,3,1,7],
            [1,7,1,1],
            [2,6,1,1],
            [2,8,1,1],
            [3,5,1,1],
            [3,9,1,1]]
  when 'L'
    return [[1,9,3,1],
            [0,3,1,7]]
  when 'l'
    return [[0,3,1,1],
            [1,3,1,7]]
  when 'M'
    return [[0,3,1,7],
            [4,3,1,7],
            [1,4,1,1],
            [3,4,1,1],
            [2,5,1,1]]
  when 'm'
    return [[0,5,1,5],
            [2,6,1,4],
            [4,6,1,4],
            [1,5,1,1],
            [3,5,1,1]]
  when 'N'
    return [[0,3,1,7],
            [3,3,1,7],
            [1,4,1,2],
            [2,6,1,2]]
  when 'n'
    return [[0,5,1,5],
            [3,6,1,4],
            [1,5,2,1]]
  when 'O'
    return [[0,4,1,5],
            [1,3,2,1],
            [1,9,2,1],
            [3,4,1,5]]
  when 'o'
    return [[0,6,1,3],
            [1,5,2,1],
            [1,9,2,1],
            [3,6,1,3]]
  when 'P'
    return [[0,3,1,7],
            [1,3,2,1],
            [1,6,2,1],
            [3,4,1,2]]
  when 'p'
    return [[0,5,1,6],
            [1,5,2,1],
            [1,8,2,1],
            [3,6,1,2]]
  when 'Q'
    return [[0,4,1,5],
            [1,3,2,1],
            [1,9,2,1],
            [3,4,1,5],
            [3,10,1,1]]
  when 'q'
    return [[3,5,1,6],
            [1,5,2,1],
            [1,8,2,1],
            [0,6,1,2]]
  when 'R'
    return [[0,3,1,7],
            [1,3,2,1],
            [1,6,2,1],
            [3,4,1,2],
            [3,7,1,3]]
  when 'r'
    return [[0,5,1,5],
            [2,5,2,1],
            [1,6,1,1]]
  when 'S'
    return [[1,3,2,1],
            [3,4,1,1],
            [0,4,1,2],
            [1,6,2,1],
            [3,7,1,2],
            [1,9,2,1],
            [0,8,1,1]]
  when 's'
    return [[1,5,3,1],
            [0,6,1,1],
            [0,9,3,1],
            [3,8,1,1],
            [1,7,2,1]]
  when 'T'
    return [[1,3,1,7],
            [0,3,3,1]]
  when 't'
    return [[1,4,1,5],
            [0,5,4,1],
            [2,9,2,1]]
  when 'U'
    return [[0,3,1,6],
            [1,9,2,1],
            [3,3,1,6]]
  when 'u'
    return [[0,5,1,4],
            [1,9,1,1],
            [2,8,1,1],
            [3,5,1,5]]
  when 'V'
    return [[0,3,1,6],
            [1,9,1,1],
            [2,8,1,1],
            [3,3,1,5]]
  when 'v'
    return [[0,5,1,4],
            [1,9,1,1],
            [2,8,1,1],
            [3,5,1,3]]
  when 'W'
    return [[0,3,1,7],
            [1,8,1,1],
            [3,8,1,1],
            [2,7,1,1],
            [4,3,1,7]]
  when 'w'
    return [[0,5,1,5],
            [1,8,1,1],
            [3,8,1,1],
            [2,7,1,1],
            [4,5,1,5]]
  when 'X'
    return [[0,3,1,3],
            [0,7,1,3],
            [1,6,2,1],
            [3,3,1,3],
            [3,7,1,3]]
  when 'x'
    return [[0,5,1,2],
            [0,8,1,2],
            [1,7,2,1],
            [3,5,1,2],
            [3,8,1,2]]
  when 'Y'
    return [[0,3,1,4],
            [1,7,1,3],
            [2,3,1,4]]
  when 'y'
    return [[3,5,1,5],
            [1,8,2,1],
            [0,5,1,3],
            [1,10,2,1]]
  when 'Z'
    return [[0,3,4,1],
            [3,4,1,1],
            [2,5,1,2],
            [1,7,1,1],
            [0,8,1,1],
            [0,9,4,1]]
  when 'z'
    return [[0,5,4,1],
            [3,6,1,1],
            [2,7,1,1],
            [1,8,1,1],
            [0,9,4,1]]
  when '1'
    return [[1,3,1,7],
            [0,4,1,1],
            [0,9,3,1]]
  when '2'
    return [[0,4,1,1],
            [1,3,2,1],
            [3,4,1,2],
            [2,6,1,1],
            [1,7,1,1],
            [0,8,1,1],
            [0,9,4,1]]
  when '3'
    return [[0,4,1,1],
            [1,3,2,1],
            [3,4,1,2],
            [1,6,2,1],
            [3,7,1,2],
            [1,9,2,1],
            [0,8,1,1]]
  when '4'
    return [[1,3,2,1],
            [0,4,1,5],
            [2,4,1,6],
            [1,8,3,1]]
  when '5'
    return [[0,3,4,1],
            [0,4,1,3],
            [1,6,2,1],
            [3,7,1,2],
            [0,8,1,1],
            [1,9,2,1]]
  when '6'
    return [[1,3,2,1],
            [0,4,1,5],
            [1,6,2,1],
            [3,7,1,2],
            [3,4,1,1],
            [1,9,2,1]]
  when '7'
    return [[0,3,4,1],
            [3,4,1,2],
            [2,6,1,2],
            [1,8,1,2]]
  when '8'
    return [[1,3,2,1],
            [0,4,1,2],
            [3,4,1,2],
            [1,6,2,1],
            [0,7,1,2],
            [3,7,1,2],
            [1,9,2,1]]
  when '9'
    return [[1,3,2,1],
            [0,4,1,2],
            [1,6,2,1],
            [3,4,1,5],
            [0,8,1,1],
            [1,9,2,1]]
  when '0'
    return [[0,4,1,5],
            [1,3,2,1],
            [1,9,2,1],
            [3,4,1,5]]
  when '.'
    return [[0,8,2,2]]
  when ','
    return [[0,8,2,2],
            [1,10,1,1]]
  when '-'
    return [[0,6,4,1]]
  when '_'
    return [[0,9,4,1]]
  when '!'
    return [[1,3,1,5],
            [1,9,1,1]]
  when '?'
    return [[0,4,1,1],
            [1,3,2,1],
            [3,4,1,2],
            [2,6,1,2],
            [2,9,1,1]]
  when '+'
    return [[0,6,5,1],
            [2,4,1,5]]
  when '~'
    return [[0,6,1,1],
            [1,5,2,1],
            [2,6,2,1],
            [4,5,1,1]]
  when '='
    return [[0,5,5,1],
            [0,7,5,1]]
  when '('
    return [[1,3,1,1],
            [0,4,1,5],
            [1,9,1,1]]
  when ')'
    return [[0,3,1,1],
            [1,4,1,5],
            [0,9,1,1]]
  when '['
    return [[1,3,1,1],
            [0,3,1,7],
            [1,9,1,1]]
  when ']'
    return [[0,3,1,1],
            [1,3,1,7],
            [0,9,1,1]]
  when '/'
    return [[0,8,1,2],
            [1,6,1,2],
            [2,4,1,2],
            [3,2,1,2]]
  when '&'
    return [[1,3,1,1],
            [0,4,1,2],
            [2,4,1,2],
            [1,6,1,1],
            [0,7,1,2],
            [2,7,1,2],
            [1,9,1,1],
            [3,9,1,1],
            [3,7,1,1]]
  when '%'
    return [[0,8,1,2],
            [1,6,1,2],
            [2,5,1,1],
            [3,3,1,2],
            [0,3,2,2],
            [2,8,2,2]]
  when '$'
    return [[1,3,2,1],
            [3,4,1,2],
            [1,4,1,6],
            [0,6,4,1],
            [0,8,4,1]]
  when '@'
    return [[1,3,4,1],
            [0,4,1,5],
            [5,4,1,3],
            [1,9,5,1],
            [1,6,1,2],
            [2,5,2,1],
            [2,7,1,1],
            [3,6,1,1],
            [4,7,1,1]]
  when '"'
    return [[0,3,1,3],
            [2,3,1,3]]
  when '<'
    return [[3,3,1,1],
            [2,4,1,1],
            [1,5,1,1],
            [0,6,1,1],
            [1,7,1,1],
            [2,8,1,1],
            [3,9,1,1]]
  when '>'
    return [[0,3,1,1],
            [1,4,1,1],
            [2,5,1,1],
            [3,6,1,1],
            [2,7,1,1],
            [1,8,1,1],
            [0,9,1,1]]
  when "'"
    return [[0,2,1,3]]
  when '*'
    return [[0,5,1,1],
            [2,5,1,1],
            [4,5,1,1],
            [1,6,3,1],
            [0,7,5,1],
            [1,8,3,1],
            [0,9,1,1],
            [2,9,1,1],
            [4,9,1,1]]
  when ':'
    return [[0,8,2,2],
            [0,4,2,2]]
  when ';'
    return [[0,8,2,2],
            [1,10,1,1],
            [0,4,2,2]]
  when '#'
    return [[3,3,1,2],
            [5,3,1,2],
            [1,5,6,1],
            [2,6,1,1],
            [4,6,1,1],
            [0,7,6,1],
            [1,8,1,2],
            [3,8,1,2]]
  when '§'
    return [[2,3,1,6],
            [3,4,1,1],
            [4,5,1,2],
            [0,8,1,1],
            [1,7,1,3]]
  end
  return [[0,3,1,7],
          [1,3,2,1],
          [1,9,2,1],
          [3,3,1,7]]
end
        
def charRectsSmallest(char)
  case char
  # List of [x,y,w,h]
  when 'A'
    return [[0,4,1,5],
            [2,4,1,5],
            [1,4,1,1],
            [1,6,1,1]]
  when 'a'
    return [[1,5,2,1],
            [0,6,1,2],
            [2,6,1,2],
            [1,8,2,1]]
  when 'B'
    return [[0,4,1,5],
            [1,4,1,1],
            [1,6,1,1],
            [1,8,1,1],
            [2,5,1,1],
            [2,7,1,1]]
  when 'b'
    return [[0,4,1,5],
            [1,6,2,1],
            [1,8,2,1],
            [2,7,1,1]]
  when 'C'
    return [[0,4,1,5],
            [1,4,2,1],
            [1,8,2,1]]
  when 'c'
    return [[0,5,1,4],
            [1,5,2,1],
            [1,8,2,1]]
  when 'D'
    return [[0,4,1,5],
            [1,4,1,1],
            [1,8,1,1],
            [2,5,1,3]]
  when 'd'
    return [[2,4,1,5],
            [0,6,2,1],
            [0,8,2,1],
            [0,7,1,1]]
  when 'E'
    return [[0,4,1,5],
            [1,4,2,1],
            [1,6,1,1],
            [1,8,2,1]]
  when 'e', 'é'
    return [[1,5,1,1],
            [0,6,3,1],
            [0,7,1,1],
            [1,8,2,1]]
  when 'F'
    return [[0,4,1,5],
            [1,4,2,1],
            [1,6,1,1]]
  when 'f'
    return [[1,5,1,4],
            [2,4,1,1],
            [0,6,3,1]]
  when 'G'
    return [[0,4,1,5],
            [1,4,2,1],
            [1,8,2,1],
            [2,7,1,1]]
  when 'g'
    return [[0,5,3,1],
            [0,6,1,1],
            [0,7,2,1],
            [2,6,1,4],
            [0,9,2,1]]
  when 'H'
    return [[0,4,1,5],
            [2,4,1,5],
            [1,6,1,1]]
  when 'h'
    return [[0,4,1,5],
            [2,6,1,3],
            [1,6,1,1]]
  when 'I'
    return [[0,4,3,1],
            [0,8,3,1],
            [1,5,1,3]]
  when 'i', 'ï'
    return [[0,4,1,1],
            [0,6,1,3]]
  when 'J'
    return [[2,4,1,5],
            [0,7,1,1],
            [0,8,2,1]]
  when 'j'
    return [[1,4,1,1],
            [1,6,1,3],
            [0,9,1,1]]
  when 'K'
    return [[0,4,1,5],
            [2,4,1,2],
            [2,7,1,2],
            [1,6,1,1]]
  when 'k'
    return [[0,4,1,5],
            [2,6,1,1],
            [2,8,1,1],
            [1,7,1,1]]
  when 'L'
    return [[0,4,1,5],
            [1,8,2,1]]
  when 'l'
    return [[0,4,1,1],
            [1,4,1,5]]
  when 'M'
    return [[0,4,1,5],
            [3,4,1,5],
            [1,5,2,1]]
  when 'm'
    return [[0,5,1,4],
            [1,5,1,1],
            [2,6,1,3],
            [3,5,1,1],
            [4,6,1,3]]
  when 'N'
    return [[0,4,1,5],
            [3,4,1,5],
            [1,5,1,1],
            [2,6,1,1]]
  when 'n'
    return [[0,5,1,4],
            [1,5,1,1],
            [2,6,1,3]]
  when 'O'
    return [[0,4,1,5],
            [2,4,1,5],
            [1,4,1,1],
            [1,8,1,1]]
  when 'o'
    return [[0,5,1,4],
            [2,5,1,4],
            [1,5,1,1],
            [1,8,1,1]]
  when 'P'
    return [[0,4,1,5],
            [1,4,2,1],
            [1,6,2,1],
            [2,5,1,1]]
  when 'p'
    return [[0,5,1,5],
            [1,5,2,1],
            [1,7,2,1],
            [2,6,1,1]]
  when 'Q'
    return [[0,4,1,5],
            [2,4,1,4],
            [1,4,1,1],
            [1,8,1,1],
            [2,9,1,1]]
  when 'q'
    return [[2,5,1,5],
            [0,5,2,1],
            [0,7,2,1],
            [0,6,1,1]]
  when 'R'
    return [[0,4,1,5],
            [1,4,2,1],
            [1,6,2,1],
            [2,5,1,1],
            [1,7,1,1],
            [2,8,1,1]]
  when 'r'
    return [[0,5,1,4],
            [1,6,1,1],
            [2,5,1,1]]
  when 'S'
    return [[0,4,3,1],
            [0,5,1,1],
            [0,6,3,1],
            [2,7,1,1],
            [0,8,3,1]]
  when 's'
    return [[1,5,2,1],
            [0,6,2,1],
            [1,7,2,1],
            [0,8,2,1]]
  when 'T'
    return [[0,4,3,1],
            [1,5,1,4]]
  when 't'
    return [[0,5,3,1],
            [1,4,1,5]]
  when 'U'
    return [[0,4,1,5],
            [2,4,1,5],
            [1,8,1,1]]
  when 'u'
    return [[0,5,1,4],
            [2,5,1,4],
            [1,8,1,1]]
  when 'V'
    return [[0,4,1,4],
            [2,4,1,4],
            [1,8,1,1]]
  when 'v'
    return [[0,5,1,3],
            [2,5,1,3],
            [1,8,1,1]]
  when 'W'
    return [[0,4,1,5],
            [3,4,1,5],
            [1,7,2,1]]
  when 'w'
    return [[0,5,1,4],
            [3,5,1,4],
            [1,7,2,1]]
  when 'X'
    return [[0,4,1,2],
            [2,4,1,2],
            [1,6,1,1],
            [0,7,1,2],
            [2,7,1,2]]
  when 'x'
    return [[0,5,1,1],
            [2,5,1,1],
            [1,6,1,2],
            [0,8,1,1],
            [2,8,1,1]]
  when 'Y'
    return [[0,4,1,2],
            [2,4,1,2],
            [1,6,1,3]]
  when 'y'
    return [[0,5,1,3],
            [2,5,1,5],
            [1,7,1,1],
            [0,9,2,1]]
  when 'Z'
    return [[0,4,3,1],
            [2,5,1,1],
            [1,6,1,1],
            [0,7,1,1],
            [0,8,3,1]]
  when 'z'
    return [[0,5,3,1],
            [1,6,2,1],
            [0,7,2,1],
            [0,8,3,1]]
  when '1'
    return [[0,5,1,1],
            [1,4,1,4],
            [0,8,3,1]]
  when '2'
    return [[0,4,3,1],
            [2,5,1,1],
            [0,6,3,1],
            [0,7,1,1],
            [0,8,3,1]]
  when '3'
    return [[2,4,1,5],
            [0,4,2,1],
            [1,6,1,1],
            [0,8,2,1]]
  when '4'
    return [[1,4,1,1],
            [0,5,1,2],
            [2,4,1,5],
            [0,7,2,1]]
  when '5'
    return [[0,4,3,1],
            [0,5,1,1],
            [0,6,3,1],
            [2,7,1,1],
            [0,8,3,1]]
  when '6'
    return [[0,4,1,5],
            [1,4,2,1],
            [1,6,2,1],
            [1,8,2,1],
            [2,7,1,1]]
  when '7'
    return [[0,4,2,1],
            [2,4,1,5]]
  when '8'
    return [[0,4,1,5],
            [2,4,1,5],
            [1,4,1,1],
            [1,6,1,1],
            [1,8,1,1]]
  when '9'
    return [[0,4,2,1],
            [0,5,1,1],
            [2,4,1,5],
            [0,6,2,1]]
  when '0'
    return [[0,4,1,5],
            [2,4,1,5],
            [1,4,1,1],
            [1,8,1,1]]
  when '#'
    return [[0,5,5,1],
            [0,7,5,1],
            [1,4,1,5],
            [3,4,1,5]]
  when '.'
    return [[0,8,1,1]]
  when ','
    return [[1,8,1,1],
            [0,9,1,1]]
  when '!'
    return [[0,4,1,3],
            [0,8,1,1]]
  when '?'
    return [[0,4,3,1],
            [2,5,1,1],
            [1,6,2,1],
            [1,8,1,1]]
  when ':'
    return [[0,8,1,1],
            [0,5,1,1]]
  when ';'
    return [[1,8,1,1],
            [0,9,1,1],
            [0,5,1,1]]
  when "'"
    return [[0,4,1,2]]
  when '"'
    return [[0,4,1,3],
            [2,4,1,3]]
  when '-'
    return [[0,6,3,1]]
  when '/'
    return [[2,4,1,2],
            [1,6,1,1],
            [0,7,1,2]]
  when '\\'
    return [[0,4,1,2],
            [1,6,1,1],
            [2,7,1,2]]
  when '%'
    return [[2,4,1,2],
            [1,6,1,1],
            [0,7,1,2],
            [0,4,1,1],
            [2,8,1,1]]
  when '~'
    return [[0,6,1,1],
            [1,5,1,1],
            [2,6,1,1],
            [3,5,1,1]]
  when '§'
    return [[2,4,1,5],
            [3,5,1,1],
            [4,6,1,2],
            [1,7,1,3],
            [0,8,1,1]]
  when '('
    return [[1,4,1,1],
            [0,5,1,3],
            [1,8,1,1]]
  when ')'
    return [[0,4,1,1],
            [1,5,1,3],
            [0,8,1,1]]
  when '['
    return [[1,4,1,1],
            [0,4,1,5],
            [1,8,1,1]]
  when ']'
    return [[0,4,1,1],
            [1,4,1,5],
            [0,8,1,1]]
  end
  return [[0,4,1,5],
          [3,4,1,5],
          [1,4,2,1],
          [1,8,2,1]]
end

class Bitmap
  def draw_text(x,y,width=nil,height=nil,string=nil,align=nil)
    return if !string
    if align==1
      width = self.text_size(string).width
      x -= width
    elsif align==2
      width = self.text_size(string).width
      x -= width / 2
      x = x.round
    end
    
    cx=x
    cy=y
    sp = 2
    
    string.split('').each { |c|
    
      if c != ' '
        rects = charRects(c,self.font.name)
        for r in rects
          r[1] -= 2
          self.fill_rect(cx+r[0]*sp,cy+r[1]*sp,(r[2]*sp).ceil,(r[3]*sp).ceil,self.font.color)
        end
      end
      
      cx += charWidth(c,self.font.name)
    }
  end
  
  def text_size(string)
    sizex = 0
    height = 32
    height = 26 if self.font.name == "Small"
    height = 22 if self.font.name == "Smallest"
    sizey = height
    total = 0
    string.split('').each { |c|
      if c == '\n'
        sizex = total if sizex < total
        sizey += self.font.size
        total = 0
      else
        total += charWidth(c,self.font.name)
      end
    }
    sizex = total if sizex < total
    return Rect.new(0,0,sizex,sizey)
  end
end


















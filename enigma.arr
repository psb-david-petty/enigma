#
# German Steckered Enigma: https://psb-david-petty.github.io/enigma
#

include string-dict

ENGLISH = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
GETTYSBURG = ```
             Four score and seven years ago our fathers brought forth on this continent, a new nation, conceived in Liberty, and dedicated to the proposition that all men are created equal.
             ```

examples:
  # Enigma test examples for development and debugging.
  enigma([list: i, ii, iii], ukw-b, 'AAA', plugboard(empty), 'aaa')
    .encode('AAAA') is 'BDZG'
  enigma([list: i, ii, iii], ukw-b, 'AAA', plugboard(empty), 'qev')
    .encode('HELLO') is 'ZJQYJ'
  enigma([list: i, ii, iii], ukw-b, 'AAA', plugboard(empty), 'adu')
    .encode('ENIGMA') is 'AOAQAG'
  enigma([list: i, ii, iii], ukw-b, 'AAB', plugboard(empty), 'aaa')
    .encode('AAAAA') is 'UBDZG'
  enigma([list: i, ii, iii], ukw-b, 'AAA', plugboard(empty), 'aaa')
    .encode(clean(GETTYSBURG)) is clean(```
             eifub mmtwt eujbl nmcob piqrr vcxsx anrbp omfgp knzlh ezdhg cqyng ywxyq uibxt nbsel fznau dbjwy ydwak tyqkr irbqp ajpef dnfel ycfvp tqicl zpgjs iniph vhsog nlwmd gknig hmp```)
  enigma([list: i, ii, iii], ukw-b, 'mmm', plugboard(empty), 'aaa')
    .encode(clean(GETTYSBURG)) is clean(```
             uuefw rhcyh ujgzi nxzlu ivqih xrhvl jeyfc nmwzw xfcdu wwyup qxhji xabhv jbcgj zylfc wcxbo mfyyf cncbr ctgok yfkqq kdwhd dbkdf psqup ddgzf qmicr eehwr evvmx qmgtf laiho nts```)
  enigma([list: v, vi, vii], ukw-b, 'mmm', plugboard([list: 'he', 'lp', ]), 'xyz')
    .encode(clean(GETTYSBURG)) is clean(```
             giacb oyeuk lnoju riiir tgzjz talth ieihk vzwlk tizri bmxks zptfz mdswa jbvlm udmbp ggewu fszom amsmp lupbw mtwrx svaxl njbvq czzdv bpqnu wsrzi iutyi pzooq bkvtw naaxd vis```)
end

data Enigma:
  | enigma(rotors :: List<Rotor>, reflector :: Reflector, rings :: String, plugboard :: Plugboard, initial :: String) with:
    # rotors - the names and orders of the rotors
    # reflector - the name of the reflector
    # rings - the settings of the rings - a string of English letters
    # plugboard - the letter pairs to swap
    # initial - the current settings of the rotors - a string of English letters
    method encode-letter(self, letter, stepped):
      doc: 'encode letter based on setup and stepped rotor settings'
      s-l = string-length
      s = string-split-all(string-to-upper(stepped), '')
      r = string-split-all(self.rings, '')
      if not(self.rotors.length() == s-l(self.rings))
        or not(s-l(self.rings) == s-l(self.initial)):
        raise('rotors, rings, settings must have same length')
      else:
        fun fr(e, a):
          doc: 'from-right foldr function where e is index and a is letter'
          from-right(a, self.rotors.get(e), s.get(e), r.get(e))
        end
        fun fl(e, a):
          doc: 'from-left foldl function where e is index and a is letter'
          from-left(a, self.rotors.get(e), s.get(e), r.get(e))
        end
        right = range(0, r.length()).foldr(fr, self.plugboard.swap(letter))
        middle = from-reflector(right, self.reflector)
        left = range(0, r.length()).foldl(fl, middle)
        self.plugboard.swap(left)
      end
    end,
    method encode(self, string):
      doc: 'encode letters of string based on setup'
      for map2(
          letter from string-split-all(string, ''), 
          index from range(0, string-length(string))):
        # TODO: not functional
        block:
          var stepped = string-to-upper(self.initial)
          for each(n from range(0, index + 1)):
            stepped := step-rotors(self.rotors, stepped)
          end
          self.encode-letter(letter, stepped)
        end
      end
        .join-str('')
    end,
end

################### Data Types ###################

data Rotor:
  | i with:
    method name(self): "I" end,
  | ii with:
    method name(self): "II" end,
  | iii with:
    method name(self): "III" end,
  | iv with:
    method name(self): "IV" end,
  | v with:
    method name(self): "V" end,
  | vi with:
    method name(self): "VI" end,
  | vii with:
    method name(self): "VII" end,
  | viii with:
    method name(self): "VIII" end,
sharing:
  method alpha(self): get-rotor(self.name()) end,
  method is-notch(self, letter):
    for any(notch from string-split-all(get-notch(self.name()), '')):
      string-to-upper(letter) == notch
    end
  end,
where:
  i satisfies is-Rotor
  ii satisfies is-Rotor
  iii satisfies is-Rotor
  iv satisfies is-Rotor
  v satisfies is-Rotor
  vi satisfies is-Rotor
  vii satisfies is-Rotor
  viii satisfies is-Rotor
  i satisfies is-i
  ii satisfies is-ii
  iii satisfies is-iii
  iv satisfies is-iv
  v satisfies is-v
  vi satisfies is-vi
  vii satisfies is-vii
  viii satisfies is-viii
  i.name() is 'I'
  i.alpha() is 'EKMFLGDQVZNTOWYHXUSPAIBRCJ'
  i.is-notch('Q') is true
  i.is-notch('A') is false
  ii.name() is 'II'
  ii.alpha() is 'AJDKSIRUXBLHWTMCQGZNPYFVOE'
  ii.is-notch('e') is true
  ii.is-notch('a') is false
  iii.name() is 'III'
  iii.alpha() is 'BDFHJLCPRTXVZNYEIWGAKMUSQO'
  iii.is-notch('V') is true
  iii.is-notch('A') is false
  iv.name() is 'IV'
  iv.alpha() is 'ESOVPZJAYQUIRHXLNFTGKDCMWB'
  v.name() is 'V'
  v.alpha() is 'VZBRGITYUPSDNHLXAWMJQOFECK'
  v.is-notch('z') is true
  v.is-notch('a') is false
  vi.name() is 'VI'
  vi.alpha() is 'JPGVOUMFYQBENHZRDKASXLICTW'
  vi.is-notch('M') is true
  vi.is-notch('Z') is true
  vi.is-notch('A') is false
  vii.name() is 'VII'
  vii.alpha() is 'NZJHGRCXMYSWBOUFAIVLPEKQDT'
  vii.is-notch('m') is true
  vii.is-notch('z') is true
  vii.is-notch('a') is false
  viii.name() is 'VIII'
  viii.alpha() is 'FKQHTLXOCBJSPDZRAMEWNIUYGV'
  viii.is-notch('M') is true
  viii.is-notch('Z') is true
  viii.is-notch('A') is false
end

data Reflector:
  | ukw-a with:
    method name(self): 'UKW-A' end,
  | ukw-b with:
    method name(self): 'UKW-B' end,
  | ukw-c with:
    method name(self): 'UKW-C' end,
sharing:
  method alpha(self): get-reflector(self.name()) end,
where:
  ukw-a satisfies is-Reflector
  ukw-b satisfies is-Reflector
  ukw-c satisfies is-Reflector
  ukw-a satisfies is-ukw-a
  ukw-b satisfies is-ukw-b
  ukw-c satisfies is-ukw-c
  ukw-a.name() is 'UKW-A'
  ukw-a.alpha() is 'EJMZALYXVBWFCRQUONTSPIKHGD'
  ukw-b.name() is 'UKW-B'
  ukw-b.alpha() is 'YRUHQSLDPXNGOKMIEBFZCWVJAT'
  ukw-c.name() is 'UKW-C'
  ukw-c.alpha() is 'FVPJIAOYEDRZXWGCTKUQSBNMHL'
end

fun get-rotor(rotor):
  doc: 'return alphabet corresponding to rotor'
  rotors = [string-dict:
    'I',    'EKMFLGDQVZNTOWYHXUSPAIBRCJ',
    'II',   'AJDKSIRUXBLHWTMCQGZNPYFVOE',
    'III',  'BDFHJLCPRTXVZNYEIWGAKMUSQO',
    'IV',   'ESOVPZJAYQUIRHXLNFTGKDCMWB',
    'V',    'VZBRGITYUPSDNHLXAWMJQOFECK',
    'VI',   'JPGVOUMFYQBENHZRDKASXLICTW',
    'VII',  'NZJHGRCXMYSWBOUFAIVLPEKQDT',
    'VIII', 'FKQHTLXOCBJSPDZRAMEWNIUYGV',
  ]
  rotors.get-value(string-to-upper(rotor))
where:
  get-rotor('I')    is 'EKMFLGDQVZNTOWYHXUSPAIBRCJ'
  get-rotor('ii')   is 'AJDKSIRUXBLHWTMCQGZNPYFVOE'
  get-rotor('III')  is 'BDFHJLCPRTXVZNYEIWGAKMUSQO'
  get-rotor('iv')   is 'ESOVPZJAYQUIRHXLNFTGKDCMWB'
  get-rotor('V')    is 'VZBRGITYUPSDNHLXAWMJQOFECK'
  get-rotor('vi')   is 'JPGVOUMFYQBENHZRDKASXLICTW'
  get-rotor('VII')  is 'NZJHGRCXMYSWBOUFAIVLPEKQDT'
  get-rotor('viii') is 'FKQHTLXOCBJSPDZRAMEWNIUYGV'
end

fun get-notch(rotor):
  doc: 'return letter before the rotor notch'
  notches = [string-dict:
    'I',    'Q',
    'II',   'E',
    'III',  'V',
    'IV',   'J',
    'V',    'Z',
    'VI',   'MZ',
    'VII',  'MZ',
    'VIII', 'MZ',
  ]
  notches.get-value(string-to-upper(rotor))
where:
  get-notch('I')    is 'Q'
  get-notch('ii')   is 'E'
  get-notch('III')  is 'V'
  get-notch('iv')   is 'J'
  get-notch('V')    is 'Z'
  get-notch('vi')   is 'MZ'
  get-notch('VII')  is 'MZ'
  get-notch('viii') is 'MZ'
end

fun get-reflector(reflector):
  doc: 'return alphabet corresponding to reflector'
  reflectors = [string-dict:
    'UKW-A', 'EJMZALYXVBWFCRQUONTSPIKHGD',
    'UKW-B', 'YRUHQSLDPXNGOKMIEBFZCWVJAT',	
    'UKW-C', 'FVPJIAOYEDRZXWGCTKUQSBNMHL',
  ]
  reflectors.get-value(string-to-upper(reflector))
where:
  get-reflector('UKW-A')  is 'EJMZALYXVBWFCRQUONTSPIKHGD'
  get-reflector('ukw-b')  is 'YRUHQSLDPXNGOKMIEBFZCWVJAT'
  get-reflector('UKW-C')  is 'FVPJIAOYEDRZXWGCTKUQSBNMHL'
end

data Plugboard:
  | plugboard(pairs :: List<String>) with:
    method swap(self, letter):
      doc: 'return swapped letter, if exists in any of pairs, otherwise letter'
      l = string-to-upper(letter)
      pair = for filter(p from validated-plugboard-list(self.pairs)):
        (l == p.first) or (l == p.last())
      end
      ask:
        | pair.length() == 0 then: l
        | l == pair.first.first then: pair.first.last()
        | otherwise: pair.first.first
      end
    end,
where:
  plugboard(empty) satisfies is-Plugboard
  plugboard(empty) satisfies is-plugboard
  plugboard(empty).swap('z') is 'Z'
  plugboard([list: 'he', 'lp', ]).swap('a') is 'A'
  plugboard([list: 'he', 'lp', ]).swap('h') is 'E'
  plugboard([list: 'he', 'lp', ]).swap('e') is 'H'
  plugboard([list: 'he', 'lp', ]).swap('l') is 'P'
  plugboard([list: 'he', 'lp', ]).swap('p') is 'L'
end

fun validated-plugboard-list(pairs):
  doc: 'return pluboard as lists after validating (pairs w/o duplicates)'
  pbl = for map(pair from pairs):
    string-split-all(string-to-upper(pair), '')
  end
  ask:
    | not(all(lam(l): l.length() == 2 end, pbl)) then:
      raise('plugboard entries not paired')
    | has-duplicates(pbl) then:
      raise('plugboard has duplicates')
    | otherwise: pbl
  end
where:
  validated-plugboard-list(empty) is empty
  validated-plugboard-list([list: 'ab', 'st', 'em', 'io', 'ux', ]) 
    is [list: [list: "A", "B"], [list: "S", "T"], 
    [list: "E", "M"], [list: "I", "O"], [list: "U", "X"]]
  validated-plugboard-list([list: 'ab', 'st', 'em', 'io', 'u', ])
    raises 'plugboard entries not paired'
  validated-plugboard-list([list: 'abstemious', ])
    raises 'plugboard entries not paired'
  validated-plugboard-list([list: 'ab', 'st', 'em', 'io', 'us', ])
    raises 'plugboard has duplicates'
end

#################### Utilities ###################

fun clean(string :: String) -> String:
  doc: 'return string with only uppercase English letters'
  for map(letter from string-split-all(string-to-upper(string), '')):
    if string-index-of(ENGLISH, letter) < 0: '' else: letter end
  end
    .join-str('')
end

fun step-rotors(rotors :: List<Rotor>, settings :: String) -> String:
  doc: 'return rotor setting stepped by one position'
  block:
    r-l = rotors.length()
    s = string-split-all(string-to-upper(settings), '')
    for map3(index from range(0, r-l), rotor from rotors, setting from s):
      block:
        # print(join-str([list: rotor.notch(), setting, index, ], ' '))

        # The Steckered Enigma M3 & M4 exhibits 'double stepping' behavior
        # - the rightmost rotor always steps
        # - the current rotor steps when the setting equals the notch
        # - OR the current rotor steps when the rotor to its right steps
        if (index == (r-l - 1)) or rotor.is-notch(setting)
          or rotors.get(index + 1).is-notch(s.get(index + 1)):
          get-letter(
            num-modulo(get-index(setting) + 1, string-length(ENGLISH)))
        else:
          setting
        end
      end
    end
      .join-str('')
  end
where:
  r123 = [list: i, ii, iii]
  step-rotors(r123, 'aaa') is 'AAB'
  step-rotors(r123, 'vvv') is 'VWW'
  step-rotors(r123, 'qev') is 'RFW'
  r678 = [list: vi, vii, viii]
  step-rotors(r678, 'yyz') is 'YZA'
  step-rotors(r678, 'yzz') is 'ZAA'
  step-rotors(r678, 'zzz') is 'AAA'
end

fun rotate-alphabet(alphabet, n):
  doc: 'return alphabet rotated by n positions, positive left / negative right'
  l = string-length(alphabet)
  p = num-modulo(n, l)
  string-substring(string-append(alphabet, alphabet), p, p + l)
where:
  rotate-alphabet('TEST', 0) is 'TEST'
  rotate-alphabet('TEST', 1) is 'ESTT'
  rotate-alphabet('TEST', 2) is 'STTE'
  rotate-alphabet('TEST', 3) is 'TTES'
  rotate-alphabet('TEST', 4) is 'TEST'
  rotate-alphabet('TEST', -1) is 'TTES'
  rotate-alphabet('TEST', -2) is 'STTE'
  rotate-alphabet('TEST', -3) is 'ESTT'
  rotate-alphabet('TEST', -4) is 'TEST'
  rotate-alphabet('TEST', 4000) is 'TEST'
  rotate-alphabet('TEST', -4000) is 'TEST'
  for map(n from range(-1, string-length(ENGLISH))):
    rotate-alphabet(ENGLISH, n)
  end is [list:
    "ZABCDEFGHIJKLMNOPQRSTUVWXY",
    "ABCDEFGHIJKLMNOPQRSTUVWXYZ", 
    "BCDEFGHIJKLMNOPQRSTUVWXYZA", 
    "CDEFGHIJKLMNOPQRSTUVWXYZAB",      
    "DEFGHIJKLMNOPQRSTUVWXYZABC", 
    "EFGHIJKLMNOPQRSTUVWXYZABCD", 
    "FGHIJKLMNOPQRSTUVWXYZABCDE",    
    "GHIJKLMNOPQRSTUVWXYZABCDEF", 
    "HIJKLMNOPQRSTUVWXYZABCDEFG", 
    "IJKLMNOPQRSTUVWXYZABCDEFGH",  
    "JKLMNOPQRSTUVWXYZABCDEFGHI", 
    "KLMNOPQRSTUVWXYZABCDEFGHIJ", 
    "LMNOPQRSTUVWXYZABCDEFGHIJK",  
    "MNOPQRSTUVWXYZABCDEFGHIJKL", 
    "NOPQRSTUVWXYZABCDEFGHIJKLM", 
    "OPQRSTUVWXYZABCDEFGHIJKLMN",  
    "PQRSTUVWXYZABCDEFGHIJKLMNO", 
    "QRSTUVWXYZABCDEFGHIJKLMNOP", 
    "RSTUVWXYZABCDEFGHIJKLMNOPQ",  
    "STUVWXYZABCDEFGHIJKLMNOPQR", 
    "TUVWXYZABCDEFGHIJKLMNOPQRS", 
    "UVWXYZABCDEFGHIJKLMNOPQRST",  
    "VWXYZABCDEFGHIJKLMNOPQRSTU", 
    "WXYZABCDEFGHIJKLMNOPQRSTUV", 
    "XYZABCDEFGHIJKLMNOPQRSTUVW",  
    "YZABCDEFGHIJKLMNOPQRSTUVWX", 
    "ZABCDEFGHIJKLMNOPQRSTUVWXY",
  ]
end

fun get-index(letter):
  doc: 'return English alphabet index for letter, A = 0, B = 1, ..., Z = 25'
  string-to-code-point(string-to-upper(letter)) - string-to-code-point('A')
where:
  for map(n from range(0, string-length(ENGLISH))): n end is
  for map(letter from string-split-all(ENGLISH, '')): get-index(letter) end
end

fun get-letter(index):
  doc: 'return English alphabet letter for index, 0 = A, 1 = B, ..., 25 = Z'
  string-split-all(ENGLISH, '').get(index)
where:
  for map(n from range(0, string-length(ENGLISH))): get-letter(n) end is
  string-split-all(ENGLISH, '')
end

fun shift-letter(letter, shift):
  doc: 'return English alphabet letter shifted by shift'
  get-letter(num-modulo(get-index(letter) + shift, string-length(ENGLISH)))
where:
  shift-letter('a', 1) is 'B'
  shift-letter('a', -1) is 'Z'
end

fun invert-alphabet(alphabet):
  doc: 'return alphabet inverted'
  letters = string-split-all(ENGLISH, '')
  for map(letter from letters):
    get-letter(string-index-of(alphabet, letter))
  end
    .join-str('')
where:
  invert-alphabet(ENGLISH) is ENGLISH
  reversed = reverse(string-split-all(ENGLISH, '')).join-str('')
  invert-alphabet(reversed) is reversed
  invert-alphabet(get-rotor('i')) is 'UWYGADFPVZBECKMTHXSLRINQOJ'
  invert-alphabet(invert-alphabet(get-rotor('i'))) is get-rotor('i')
end

fun caesar(letter, alphabet):
  doc: 'return letter encoded by alphabet'
  string-split-all(alphabet, '').get(get-index(letter))
where:
  caesar('a', rotate-alphabet(ENGLISH,  0)) is 'A'
  caesar('b', rotate-alphabet(ENGLISH, -1)) is 'A'
  caesar('n', rotate-alphabet(ENGLISH, 13)) is 'A'
end

fun from-right(letter, rotor, setting, ring):
  doc: 'return letter encoded by rotor set to shift and shifted'
  block:
    s = get-index(setting) - get-index(ring)
    l = caesar(letter, rotate-alphabet(rotor.alpha(), s))
    shift-letter(l, -1 * s)
  end
where:
  # TODO: write more principled tests
  from-right('A', i, 'A', 'A') is 'E'
end

fun from-reflector(letter, reflector):
  doc: 'return letter reflected from reflector'
  zero = get-letter(0)
  from-right(letter, reflector, zero, zero)
where:
  for map(reflector from [list: ukw-a, ukw-b, ukw-c, ]):
    for map(letter from string-split-all(ENGLISH, '')):
      from-reflector(from-reflector(letter, reflector), reflector)
    end
      .join-str('') is ENGLISH
  end
end

fun from-left(letter, rotor, setting, ring):
  doc: ''
  block:
    s = get-index(setting) - get-index(ring)
    l = shift-letter(letter, s)
    caesar(l, invert-alphabet(rotate-alphabet(rotor.alpha(), s)))
  end
where:
  # TODO: write more principled tests
  from-left('A', i, 'A', 'A') is 'U'
end

fun flatten(nested):
  doc: 'return flattened multi-dimensional list'
  # https://stackoverflow.com/a/8387641
  ask:
    | is-empty(nested) then: empty
    | is-link(nested) then: append(flatten(nested.first), flatten(nested.rest))
    | otherwise: [list: nested, ]
  end
where:
  flatten(empty) is empty
  flatten([list: 1, 2, 3, 4, ]) is [list: 1, 2, 3, 4, ]
  flatten([list: [list: 1, 2, ], [list: 3, 4, ]]) is [list: 1, 2, 3, 4, ]
  flatten([list: [list: 1, [list: 2, ]], [list: 3, ], [list: 4, ]]) is [list: 1, 2, 3, 4, ]
end

fun has-duplicates(unique):
  doc: 'return true if flattened unique has duplicates, otherwise false'
  # https://stackoverflow.com/a/33115059
  flattened = flatten(unique)
  ask:
    | is-empty(flattened) then: false
    | member(flattened.rest, flattened.first) then: true
    | otherwise: has-duplicates(flattened.rest)
  end
where:
  has-duplicates(empty) is false
  has-duplicates([list: 1, ]) is false
  has-duplicates([list: 1, 2, ]) is false
  has-duplicates([list: 1, 2, 3, ]) is false
  has-duplicates([list: 1, 2, 3, 4, ]) is false
  has-duplicates([list: 1, 1, 3, 4, ]) is true
  has-duplicates([list: 1, 2, 2, 3, ]) is true
  has-duplicates([list: 1, 2, 3, 3, ]) is true
end

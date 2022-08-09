# enigma

This is an exercise in [Pyret](http://pyret.org/) used to explore [functional programming](https://dcic-world.org/2022-01-25/) and the [German Steckered Enigma Machine](https://www.cryptomuseum.com/crypto/enigma/working.htm).

## What did I learn about [Pyret](http://pyret.org/)?

- Using `example`s is a good technique for thinking through and prototyping a multifacted problem like `Enigma`.
- I like the [`ask`](https://www.pyret.org/docs/latest/Expressions.html#%28part._s~3aask-expr%29) syntax better than `else if` because if most resembles [`cond`](https://docs.racket-lang.org/reference/if.html).
- Using `data` types is a way to create variant constructors. It also means that the variants fill the namespace (*e.g.* the `Rotor` datatype includes `i`, `ii`, `iii`, `iv`, `v`, `vi`, `vii`, and `viii` variants).
- I have been trying to resolve the `fun` versus `method` dichotomy. To that end, I had a good [discussion](https://groups.google.com/g/pyret-discuss/c/lmnJX0VWPZU) w/ [Ben Lerner](https://www.ccs.neu.edu/home/blerner/) *et al.* on the [pyret-discuss](https://groups.google.com/g/pyret-discuss/) Google group.
- There are a lot of places where `string-split-all(string-to-upper(string), '')` is required. When is it optimal to convert to uppercase and why is there no `map(letter from 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'):`?
- There is no notion of *character* other than a one-length `String`. Is it best to convert every multi-character `String` to a `List`?
- The `encode` method uses a variable to keep track of an accumulated value as described in the entry for [`each`](https://www.pyret.org/docs/latest/lists.html#%28idx._%28gentag._264%29%29). There must be a recursive value for this loop.

## What did I learn about the [Enigma Machine](https://www.cryptomuseum.com/crypto/enigma/)?

- The Enigma emulators (linked below) were *extremely* helpful in debugging the behavior of this code.
- The heart of the Enigma is as follows:
  - swap letter from the keyboard through the plugboard
  - transmit letter through the rotors from right to left
  - transmit letter through the reflector
  - transmit letter through the rotors from left to right
  - swap letter through the plugboard to the lampboard

  as embodied with this code:

```Pyret
        right = range(0, self.rotors.length()).foldr(fr, self.plugboard.swap(letter))
        middle = from-reflector(right, self.reflector)
        left = range(0, self.rotors.length()).foldl(fl, middle)
        self.plugboard.swap(left)
```  

- The [M3 Enigma Machine](https://www.cryptomuseum.com/crypto/enigma/m3/) features ['double stepping'](https://www.cryptomuseum.com/people/hamer/files/double_stepping.pdf) of the rotors. Consequently, a rotor will step when the rotor to its right's setting matches its notch *or* when its own setting matches its notch. (The rightmost rotor always steps.)
- Rotors `vi`, `vii`, and `viii` have *two* notch positions, so `is-notch` had to be added to look for either notch.
- The `from-left` function needs an inverted alphabet. `invert-alphabet` uses an ![order n squared](https://latex.codecogs.com/png.latex?\dpi{100}\mathcal{O}\left(n^{2}\right)) algorithm to repeatedly find corresponding letters. Using a `string-dict` could make it ![order n](https://latex.codecogs.com/png.latex?\dpi{100}\mathcal{O}\left(n\right)).

## Links

| Link | Description |
| --- | --- |
| [https://pyret.org/](https://pyret.org/) | Pyret.org |
| [https://code.pyret.org/](https://code.pyret.org/) | Pyret.org coding IDE |
| [https://dcic-world.org/2022-01-25/](https://dcic-world.org/2022-01-25/) | DCIC reference textbook |
| [https://www.pyret.org/docs/latest/A_Tour_of_Pyret.html](https://www.pyret.org/docs/latest/A_Tour_of_Pyret.html) | A tour of Pyret |
| [https://www.pyret.org/docs/latest/Expressions.html](https://www.pyret.org/docs/latest/Expressions.html) | Pyret *Expressions* (tab open for reference) |
| [https://www.pyret.org/docs/latest/lists.html](https://www.pyret.org/docs/latest/lists.html) | Pyret *`List`s* (tab open for reference) |
| [https://www.pyret.org/docs/latest/strings.html](https://www.pyret.org/docs/latest/strings.html) | Pyret *`String`s* (tab open for reference) |
| [https://cryptomuseum.com/crypto/enigma/working.htm](https://cryptomuseum.com/crypto/enigma/working.htm) | CryptoMuseum &mdash; *How does an Enigma machine work?* | 
| [https://cryptii.com/pipes/enigma-machine](https://cryptii.com/pipes/enigma-machine) | Enigma Machine emulator |
| [https://101computing.net/enigma-machine-emulator/](https://101computing.net/enigma-machine-emulator/) | Enigma Machine emulator |
| [https://en.wikipedia.org/wiki/Enigma_rotor_details](https://en.wikipedia.org/wiki/Enigma_rotor_details) | Enigma Machine rotor details |
| [https://cryptocellar.org/enigma/wiring-catalog/enigma_rotor_catalog_full.pdf](https://cryptocellar.org/enigma/wiring-catalog/enigma_rotor_catalog_full.pdf) | *Catalog of Enigma Cipher Machine Wirings* &mdash; declassified 1954 report |

<hr>

[&#128279; permalink](https://psb-david-petty.github.io/enigma) and [&#128297; repository](https://github.com/psb-david-petty/enigma) for this page.

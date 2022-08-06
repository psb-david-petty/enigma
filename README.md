# enigma

This is an exercise in [Pyret](http://pyret.org/) used to explore [functional programming](https://dcic-world.org/2022-01-25/) and the [German Steckered Enigma Machine](https://www.cryptomuseum.com/crypto/enigma/working.htm).

## What did I learn about [Pyret](http://pyret.org/)?

- Using `example`s is a good technique for 

## What did I learn about the [Enigma Machine](https://www.cryptomuseum.com/crypto/enigma/)?

- The heart of the Enigma is as follows:
  - swap letter from the keyboard through the plugboard
  - transmit letter from through the rotors from right to left
  - transmit letter through the reflector
  - transmit letter from through the rotors from left to right
  - swap letter through the plugboard to the lampboard

  as embodied with this code:

```Pyret
        right = range(0, r.length()).foldr(fr, self.plugboard.swap(letter))
        middle = from-reflector(right, self.reflector)
        left = range(0, r.length()).foldl(fl, middle)
        self.plugboard.swap(left)
```  

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


# About

implement [TextRank](https://web.eecs.umich.edu/~mihalcea/papers/mihalcea.emnlp04.pdf) in LuaJIT with a modified [thunlp/THULAC](https://github.com/thunlp/THULAC).

text_rank.lua required

- [LuaJIT](https://github.com/LuaJIT/LuaJIT)
- [THULAC](https://github.com/lalawue/THULAC)
- [GloVe](https://github.com/stanfordnlp/GloVe)

# Usage

```bash
$ Usage: luajit text_rank.lua 'WORD_VECTORS.TXT' 'SUMMARIZE_COUNT' 'INPUT_TEXT'
```

- compiile THULAC, place libthulac.dylib or libthulac.so into lib/ dir
- download models for THULAC, put models into lib/models
- unpack data/demo_vectors.tar.gz as 'tar xjf data/demo_vectors.tar.bz2 -C data'
- 'export DYLD_LIBRARY_PATH=$PWD/lib' or 'export LD_LIBRARY_PATH=$PWD/lib'
- 'luajit text_rank.lua data/demo_vectors.txt 10 test/test_input.txt'

# Build your own GLoVe vectors

- download Chinese corpus, for example download from http://www.sogou.com/labs/ and clean it with tools/clean_sogocs_text.lua
- using [THULAC](https://github.com/lalawue/THULAC) to segment word for GloVe
- download [GloVe](https://github.com/stanfordnlp/GloVe) and make vectors.txt
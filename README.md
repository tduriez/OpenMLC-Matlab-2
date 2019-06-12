### OpenMLC-Matlab-2

A new implementation of OpenMLC (https://github.com/MachineLearningControl/OpenMLC-Matlab) for Matlab.

## What is different from OpenMLC-Matlab ?

Faster: Individuals are hashed and thus all comparisons are done in a breath, only identical hashes are checked.

More information: individuals have now their own class and keep a small database of their history, including all past evaluations and evaluation time.

More options: Leaf probability, 4 mutation types, Different population sizes,  subpopulations, cascading.

Slight changes for the scripts. If you have evaluation scripts for OpenMLC, please note that individuals are a bit different: idv.value is now the LISP expression (and they have the root operator even if only one branch is used), while a MATLAB interpretable expression can be found at idv.formal.

More bugs: More code means more bugs. Please report at https://github.com/tduriez/OpenMLC-Matlab-2/issues.

### What is MLC exactly

Machine Learning Control is a framework develloped in order to control experimental complex systems without the need for modeling. It is based on the direct regression of a control law which minimizes a cost functionnal.

You can find more information about MLC in the [MLC Book](http://www.springer.com/us/book/9783319406237) or check [this page](http://laboratorios.fi.uba.ar/lfd/thomas-duriez/) for related publications.

### I want a new feature

While I will fix bugs under finite time, I will only be including new features that serves my work or through pull request.

Have fun, T.

### Copyright and License

    Copyright (C) 2015-2019 Thomas Duriez.
    This file is part of the OpenMLC-Matlab-2 Toolbox. Distributed under GPL v3.

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.

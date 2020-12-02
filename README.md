# JSO Numerical Experiments Template

This template can be used for numerical experiments when creating JSO-compliant solvers.

## Framework

Create **two** repositories, one for the solver, one for the numerical experiments.
You can use [JSOSolverTemplate.jl](https://github.com/abelsiqueira/JSOSolverTemplate.jl) as a template for a JSO-compliant solver and this package as template for the experiments.

## dev ../YourPackage.jl

Since you want to develop both packages at the same time, you should:

- open Julia in this folder
- If not on VSCode, I recommend installing Revise and `julia> using Revise`
- `pkg> activate .` and `pkg> instantiate` if necessary
- `pkg> dev ../YourPackage.jl`

Therefore you can edit your package and run the scripts for testing here, without leaving garbage on your package.
Furthermore, you can (should?) release this repository to show how the numerical experiments were made.

## Dr. Watson

You can use DrWatson.jl (link pending) to help in the numerical experiments part.
I don't use it here yet, because it is a little bit overkill for our usual tests.
# tf-modules
Various modules for terraform

## Structure
`modules` folder is where all modules are stored.
* modules are grouped per provider
* each provider folder is itself a module that includes child modules (gcp/network, gcp/iam). That are turned on and off based on vars passed to provdider module

## TBD
* Add docs for each module

## More info

Checkout https://github.com/ggramal/infrared for more info

## Prerequisites
Before doing anything please follow this steps
1. Install pre-commit `pip install pre-commit`
2. Clone this project
3. Run `pre-commit install` from the project dir

# tf-modules
Various modules for terraform

## Structure
`modules` folder is where all modules are stored.
* modules are grouped per provider
* each provider folder is itself a module that includes child modules (gcp/network, gcp/iam). That are turned on and off based on vars passed to provdider module

## More info

Checkout https://github.com/ggramal/infrared for more info

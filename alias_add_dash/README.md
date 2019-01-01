# alias_add_bash

These script allows you to add the complementary lines for your bash aliases.

## Usage

alias_add_bash file

## Exemple
```
% cat test           
alias test_test_test="test"


alias test-test-test="test"

alias test_test-test="test"

alias test_test_test="test"
alias test-test-test="test"
% ./alias_add_dash.sh test
% cat test                
alias test_test_test="test"
alias test-test-test="test"


alias test_test_test="test"
alias test-test-test="test"

alias test_test-test="test"

alias test_test_test="test"
alias test-test-test="test"
alias test_test_test="test"
alias test-test-test="test"
```

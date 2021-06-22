## [Loops](https://docs.ansible.com/ansible/latest/user_guide/playbooks_loops.html)

* Comparing `loop` and `with_*`
* Standard loops
    * Iterating over a simple list
    * Iterating over a list of hashes
    * Iterating over a dictionary
    * Registering variables with a loop
* Complex loops
    * Iterating over nested lists
    * Retrying a task until a condition is met
    * Looping over inventory
* Ensuring list input for `loop`: using `query` rather than `lookup`
* Adding controls to loops
    * Limiting loop output with `label`
    * Pausing within a loop
    * Tracking progress through a loop with `index_var`
    * Defining inner and outer variable names with `loop_var`
    * Extended loop variables
    * Accessing the name of your loop_var
* Migrating from with_X to loop
    * with_list
    * with_items
    * with_indexed_items
    * with_flattened
    * with_together
    * with_dict
    * with_sequence
    * with_subelements
    * with_nested/with_cartesian
    * with_random_choice

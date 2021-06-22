## [xattr state absent sets attribute to empty](https://github.com/ansible/ansible/issues/24917)

### STEPS TO REPRODUCE
```
- name: Set attributes
  xattr:
    path: "{{ test_file }}"
    key: user.foo
    value: bar

- name: Unset attribute
  xattr:
    path: "{{ test_file }}"
    key: user.foo
    state: absent
  register: xattr_unset_result

- name: get attributes
  xattr:
    path: "{{ test_file }}"
  register: xattr_get_after_unset_result

- name: print result
  debug: var=xattr_get_after_unset_result['xattr']
```

### EXPECTED RESULTS
```
xattr_get_after_unset_result['xattr'] == { }
```

### ACTUAL RESULTS
```
xattr_get_after_unset_result['xattr'] == { "user.foo": "" }
```
```
TASK [xattr : Set attributes] **************************************************
changed: [testhost] => {"changed": true, "msg": "user.foo set to bar", "xattr": {}}

TASK [xattr : Unset attribute] *************************************************
changed: [testhost] => {"changed": true, "msg": "user.foo removed", "xattr": {"user.foo": "bar"}}

TASK [xattr : get attributes] **************************************************
ok: [testhost] => {"changed": false, "msg": "returning None", "xattr": {"user.foo": ""}}

TASK [xattr : print result] ****************************************************
ok: [testhost] => {
    "xattr_get_after_unset_result['xattr']": {
        "user.foo": ""
    }
}
```

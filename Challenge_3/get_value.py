input_object = {"Grandfather":{"Father":{"Son":"Grandson"}}}                                     #Nested Object, can also be passed as input argument
key_sequence = input("Enter the Key or sequence of keys of a nested object, seperated by '/':")  #Input the Key or Sequence of keys to get the value
nested_key = key_sequence.split ("/")                                                            #Create a list for the input keys
def nested_get_value(input_object, nested_key):
    dict_value = input_object
    for k in nested_key:                                                                         # Loop Operation for the item in list of keys "nested_key"
        dict_value = dict_value.get(k, None)                                                     # Stores the value of the key
        if dict_value is None:
            return None
    return dict_value
if __name__ == '__main__':
	print(nested_get_value(input_object, nested_key))
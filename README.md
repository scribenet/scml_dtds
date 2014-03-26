# The DTD

This is the home of the ScML DTD.

## Updating the DTD

- Make sure to the version number.
- Make sure to add comments to the reason/occasion and the names of thos involved.

## Testing the DTD

The file test_dtd.rb exists for testing examples against the DTD to verify that it behaves as expected.

### Running the Tests

- In the command line: `ruby test_dtd.rb`
And to run a specific test:
- `ruby test_dtd.rb --name [name of the specific test]

### Adding Tests

Follow the format seen in the existing methods:

- All test methods must begin with `test_`
- Write example scml into the @input variable
- Assert either `is_valid` or `is_not_valid`

# The DTD

This is the home of the ScML and sam DTDs.

## Updating the DTD

The DTDs should be generated using the elements.yml and scml_generator in the scribenet/scml_builder repo. Elements and validation rules should be altered within the elements.yml file. In the templates directory in that repo, there are templates for the static portions of the DTD. Make additions to those templates and process a new copy of the DTD. We strongly discourage making manual updates to the DTD copies in this repo because that creates information not easily portable to the other iterations of the tag list.

When changing the DTD templates:

- Make sure to the version number.
- Make sure to add comments to the reason/occasion and the names of those involved.

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

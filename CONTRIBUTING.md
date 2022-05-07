# How to contribute

If you're reading this file, then you must be interested interested in helping out with this project. Thank you!

Anyone is invited to propose changes, fixes, and new features through pull requests in this repository. The following guidelines are intended to keep the commit history clean and easy to read.

## Testing

You can run the included unit tests by installing [busted](https://olivinelabs.com/busted/) and running `busted .` in the root directory. Please also feel free to extend these unit tests, especially if you're adding new functionality to the autotracker.

The tests will also be run automatically for your pull requests.

## Contributing

If you're making changes to the autotracker, please use the `autotracker` branch as the base for your PR. Ideally, the autotracker should stay compatible with Hamsda's pack. This will make it easier for Hamsda to merge this work into their pack if they choose to do so.

Any changes that you propose *outside* the scope of the autotracker should be based on `master`.

Please create a pull request with a clear explanation of what you've done; read more about pull requests [here](http://help.github.com/pull-requests/).

When you feel that your PR is ready to merge, you should rebase it into as few commits as possible. Rebasing is encouraged to help keep the commit history readable.

This repository generally follows the [Chris Beams standards](https://cbea.ms/git-commit/) for commit messages:

    Separate subject from body with a blank line
    Limit the subject line to 50 characters
    Capitalize the subject line
    Do not end the subject line with a period
    Use the imperative mood in the subject line
    Wrap the body at 72 characters
    Use the body to explain what and why vs. how

Thank you for contributing, and I look forward to reviewing your work.

# Contributing

When contributing to this repository, please first discuss the change you wish to make by opening a new issue. 

Please note we have a code of conduct, please follow it in all your interactions with the project.

## Owner

SMHS Schedule is created by **Jingwen (Jevon) Mao**

The current owner is **Jingwen (Jevon) Mao**

Email: woodburyjevonmao@gmail.com

Discord: Jevon#2448

## Pull Request Process

1.  Find an issue to work on or open a new issue for a feature or bug fix

2.  Fork and clone this repository

3.  Make a new branch and name it with issue number + short description (ex. #23-feature-new-color)

4.  If needed, update the README.md with details of changes of APIs

5. Open a pull request

### Branch Protection
We have branch protection in place for main branch, I will review and merge your PR if all CI checks have passed. The CI checks are automatically triggered on pull request or push to main branch, and may include: build, unit tests, format linting, documentation coverage, and Cocoapods linting. 

## Label Meanings

SMHS Schedule's open source community uses several different tags to efficiently categorize and manage issues. 

#### `work in progress`
Any issue labeled with this tag means that it is already work in progress, either by the owner or other contributors. While discussion and comments are still welcome, it usually means that this issue is not open for contributing.

#### `possible bug`
Issue opened with bug template will automatically be labeled with the `possible bug` tag. A possible bug that has not been reviewed by a maintainer or the owner, and will not yet be worked on.

#### `confirmed bug`
A `confirmed bug` label means that the bug has been reviewed and confirmed by maintainers, and will be worked on to be fixed.

#### `feature request`
Issue opened with the feature template will automatically be labeled with this tag. It is a request, or a pitch, for a new feature, but the request has not been reviewed by a maintainer or the owner yet.

#### `enhancement`
This tag is an evolution of the `feature request` tag. The feature request has been reviewed and confirmed by maintainers, and will be implemented in future versions.

#### `good first issue` & `intermediate quest` & `hard quest`
Bugs and features that need to be worked on are also called "quest", which is a name inspired by many RPG games. Those represent the approximate difficulty and complexity of the given issue. 


## Releasing and Deploying

### Pre-Releasing
- Pass all test suites
- Update onboarding modal for features

### Releasing
For each numbered version release, it is important to follow semantic versioning guidelines.

- Bump version in `SMHSSchedule.xcodeproj`
- Verify build number for all targets
- Update changelog with changes (ignore for now)
- Tag new version:
```
$ git tag -a <VERSION> -m "<MESSAGE>"
$ git push origin --tags
```
- Commit and push changes 

 

# Introduction
Some things just can't be handled by tests.
While it is easily checked, whether a function uses a given command, it is a lot harder to automate style verification or how well the pipeline has been implemented.
For these kinds of tests, the human eye is required.
However, this manual verification _can_ be done in a way, that an automated test can recognize.

This leads us to the tag system:
The reviewer doing the final verification adds the tags that show the function has been tested for whatever the reviewer tested.
The tests will pick up the tests and show, that the function has been thus verified.

# Tagging a function
Now, the tests will only check the _first line_ in a given script file. If there is a line for the tags, it will interpret and use them.

Here's an example tag:
`#ValidationTags#Tags,That,Will,Be,Considered#`

Each prerequisite requiring manual sign-off has its own associated tag.

# Prerequisites that require manual sign-off

## Code Style
Tag: CodeStyle
A function that meets all requirements for code-style should be tagged with the "CodeStyle" tag.
See the Style guide for what style requirements dbatools has for its functions.

## Messaging Usage
Tag: Messaging
Functions must use the internal messaging system, in order to properly support debugging and logging, as well as responding to verbosity configurations.
See the Messaging guide for what needs to be considered for the messaging system.
Tier 1 implementation is required for the 1.0 release.

## Flow Control
Tag: FlowControl
Functions must implement proper control of the function flow. The basic premise here is that we want to implement as smooth an experience for the users as we can manage.
This requires:
 - All actions that can fail must be caught and interpreted for the use
 - All functions must cease operation once success is impossible (e.b.: Continue with the next item when connecting to a server failed, rather than try doing all the things that cannot succeed without that connection)
 - All functions must provide sufficient debug information in case of error (errors that were caught must also be logged)
 - All functions must respect the Silent parameter, forcing the return of exceptions that can be caught. This is critical in order to support people writing scripts around dbatools.
For details on implementing this, see the flow control guide.

## Pipeline implementation
Tag: Pipeline
For the most intuitive user experience, supporting the pipeline is required. All functions must thus be inspected for ...
 - Is it meaningful to implement pipeline support
If it is, it should also be considered:
 - What data is accepted via pipeline
 - Will it properly process items within the pipeline and produce output that can be used in the next element within the pipeline
 - All per-item actions, including output, should happen within the process block. Begin and End only exist to perform once-only actions.

# Full Example
`#ValidationTags#CodeStyle,Messaging,FlowControl,Pipeline#`
This tag guarantees that all tests requiring manual sign-off have been passed.
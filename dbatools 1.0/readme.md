# dbatools 1.0
Release Objective: June 1st, 2017

The 1.0 release is the objective to provide a solid core of dbatools, that have been cleaned up, bugfixed and brought to a common standard of code.

The process of reaching there consists of two parts:
 - A sequence of phases for the main overhaul of all code to an equal standard
 - Individual impromptu tasks, that are triggered by occurences outside of the main sequence

# Sequence
## Phase 1: Defining the desired state
We'll need to define requirements (Separately for internal versus public functions)
For each such requirement, we need an implementation guide.

## Phase 1.5: Implementing tests to track progress on implementing requirements
Each requirement must be covered by a test. Some things we can catch technically, some we need to handle by manual sign-off as part of a review.
Functions that have been signed-off as meeting a specific prerequisite must be marked by a comment-tag at the top of the file (Tag to be determined while defining the prerequisite)

## Phase 2: Implementation and Progress tracking
Teams of coders tackle one function after another, in order to bring them into compliance.
Compliance means:
 - All open issues are resolved
 - All requirements are met (Tests pass)
Any issues that arise outside of our requirements need to be dealt with:
 - Small or non-affecting issues we queue for phase 3
 - Major issues may force us to revisit phase 1, adapting our requirements. This will probably force us to go over already passed content from previous phase 2 iterations.

After finishing this, we have reached a state of sufficiency: We could release now, but may want to refine some more. Basically, phase 1 & 2 are for ensuring our minimum level of quality.

## Phase 3: Extension
We will absolutely find things that don't fit into our framework of requirements. Critical issues cause an immediate rollover into phase 1, but lesser matters get queued for later. If we make it in time, we'll add them to 1.0, otherwise it's for a later edition.


# Tasks
## Task 1: New commands
There will still be contributors that want to add new functions. While we ask for a freeze and desire contributors to help us bring all functions into compliance, it is unrealistic to expect them all to do so.
In order to avoid descent into chaos, new PRs must meet all automatic test requirements and follow the guidelines close enough to receive sign-off for those tests that cannot reasonably be automatically covered.

Decision on whether a function will be accepted at all lies with Chrissy LeMaire.
All such new submits will then be assigned to a specific team-member that will handle the compliance sign-off.

## Task X: The unknown
There will be issues we didn't think of. For this reason, some aspects cannot be handled by a blanket plan. Instead, a capacity to react must remain available, so we can avoid backlog from causing a chain reaction.
Due to this, team-members should avoid assigning them too big chunks of workload at a time.
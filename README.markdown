Teamworker
==========

This Rails web application has originated to help solve two specific problems that are common in technology departments:

1. Ensure that the people supply is balanced against demand for work to be done
2. Manage budget (FTE) for projects in progress

There are many different ways of doing this already (Excel in particular!), but nothing has really adequately met our needs because we have significantly changed our operating model at work towards:

* Teams over individuals
* Releases over projects

This philosophical change highlighted that many of our business processes and systems are geared the other way around which although may be easier to manage, they ultimately lead to a significant amount of waste.  It was because of this that we have seen a need for Teamworker - a tool to support our new way of operating.

Along the way it will hopefully also provide assistance for other related areas:

* People skills and roles
* Scrum team performance (days/point)
* Timesheeting for teams (as opposed to individuals)
* Release supply capacity

Status
------

The application is in its infancy and not ready for consumption yet.  I'll update the README file when its in working order!

Ideas
-----
* Projects should have a budget tolerance that can be tracked against for control
* Monthly timeboxes against a project can show how you plan to spend the budget
* Sprint timeboxes against a project can help produce a release burndown by points
* Project reporting has several facets:
  * Completed points against total points per team
  * Completed days against total days
  * Cost of days per point per team to predict total remaining costs
* Some timeboxes have demand that completely matches supply (i.e. project secondment, DevOps, leadership team, production support)
* Have an unconfirmed team to capture possible project demand that is in the early stages of initiation
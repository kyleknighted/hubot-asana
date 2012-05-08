Asana for Hubot
===============

Add all tasks to a bucket in Asana

* Add asana.coffee to your Hubot scripts directory
* Add your Workspace ID 
  * `curl -u <api_key>: https://app.asana.com/api/1.0/workspaces`
* Add your Project ID
  * `curl -u <api_key>: https://app.asana.com/api/1.0/workspaces/WORKSPACE_ID_FROM_STEP_2/projects`
* Add your bot's API key (make sure you added your bot to the workspace)

Command to add projects include

* `todo: Add your task here`
* `todo: @kyle Add kyle's task here`
* `task: @knight Add kyle's task here`

It accepts both `todo:` or `task:` for the same thing.  
I'll be working on cleaning the code up a bit, and trying to add more features.

The Asana API is pretty limited in what it can do without lots of calls and processing to get bits of info.  
Feel free to fork it and help out or provide Issues of problems or ideas.

This will match first and last names of users who are associated to the workspace already.

Feel free to checkout the Asana API @ http://developer.asana.com/documentation/
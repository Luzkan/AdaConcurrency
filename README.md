# AdaConcurrency
Concurrency Projects in Ada language.

*For Go version of Projects in this repo [click here (Go Repo)](https://github.com/Luzkan/GoConcurrency).*

## Projects
In the order of creation:

### #1: MathBusiness 
It's a small business simulator managed by a boss with small personel. 
Boss creates random tasks for his fellas and puts them in a magazine.
Workers are taking those tasks from the magazine and solves them.
After doing their job they are passing the results of their work to another magazine.
From the second magazine those results can be bought by customers. 

It's all thread managed; the tasks are simple equations; performance and number of people can be adjusted in config file.

Additionally there is 'silence' and 'verbose' in which console prints out either live preview of what's going on or in the case of the latter - user can use commands to check state of Magazines.


### #2: MathBusiness but with Machines
Due to weak bones and lack of calcium company decided to invest in machines to make things ~~harder~~ easier.
Now Workers are not solving the tasks themselves but instead they are using machines. Machine is not as good as workers were before and they need some time to solve the task. Because of enourmous crowd of workers and lack of proper amount of machines people there form ques to use them. Or they don't. Actually it depends on the type of worker as he can be either patient or just run around looking for an empty machine until he finds one.

Silent mode got new option - printing worker stats and informations.

Accept, selects and guards added.

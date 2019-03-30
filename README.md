# GoConcurrency
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

<h2> Single Value Decomposition: Introduction </h2>
<p> SVD is a method that allows the decomposition of any matrix into two matrices made of orthonormal eigenbases, and a matrix of corresponding eigenvalues. Basically, any matrix A can be rewritten in the form U sigma V*, and U and V are special because they’re unitary basis vectors, and their inverses are their transposed matrices; this makes calculations a lot easier. The values in the sigma matrix correspond to how much a particular basis participates in the data; it kind of ranks the eigenvectors in terms of “importance”. The eigenvectors with larger eigenvalues will appear toward the top of the matrices. A similar matrix of the original matrix A can be reconstructed with a lower resolution by just using a specified number of “important” modes; the eigenvalues tend to drop off sharply after a certain point, so you only end up having to include, let’s say, 100 rows instead of 1,000,000, because the 999,900 other rows are rather insignificant.</p> <br>


<h2> Analysis of Dataset </h2>
<h3> Looking at eigenvalue vs mode index </h3>
<p> After setting up and computing the SVD using the MATLAB functon, we are given the $\sigma$
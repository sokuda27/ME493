<h2> Eigensystem Realization Algorithm: Introduction </h2>
<h3> Summary</h3>
<img src="images/summary.png">
<p> Source: http://www.systemidtechnologies.com/approach/chapter5/ </p>

<h3> Method </h3>
<ol>
    <li> Hankel Matrix.
    <ul id="ind">
        <li> $ \begin{align}
            \label{Eq: Hankel matrix k}
            \boldsymbol{H}_k^{(p, q)} = \begin{bmatrix}
            h_{k+1} & h_{k+2} & \cdots & h_{k+q}\\
            h_{k+2} & h_{k+3} & \cdots & h_{k+q+1}\\
            \vdots & \vdots & \ddots & \vdots\\
            h_{k+p} & h_{k+p+1} & \cdots & h_{k+p+q-1}\\
            \end{bmatrix} = \boldsymbol{O}^{(p)}A^{k}\boldsymbol{R}^{(q)}.
            \end{align} $
</ol>

<br>

<head>
<style>
.row:after {
    content: "";
    display: table;
    clear: both;
}
.column {
    float: left;
    width: 50%;
}
#ind
{
 text-indent:50px;
}
</style>
</head>
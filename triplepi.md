The mutually reinforcing aggregation operators have the characteristic that they consider the scale in bipolar form. If all evaluations are positive (greater than 0.5), they reinforce each other and the result will be greater than or equal to the maximum of the evaluation values. On the contrary, if all evaluations are negative, then the resulting value will be less than the lowest of the individual evaluations.

The best-known aggregation operator in this family of operators is known as 3-Pi, which is calculated as follows:
$$
F(x_1, x_2, \ldots, x_n) = \frac{\prod_{i=1}^n x_i}{\prod_{i=1}^n x_i + \prod_{i=1}^n 1- x_i}
$$

More information on this operator can be found [here](https://pdfs.semanticscholar.org/4aec/8aab138d999c396c8fa51982a404415ebdf5.pdf).
"""
Force-Scheme
"""

import numpy as np

tol = 1.e-6    # zero tolerance

def pdist(x):
    """
    Pairwise distance between pairs of objects
    TODO: find a fast function
    """
    n, d = x.shape
    dist = np.zeros((n, n))
    for i in range(n):
        for j in range(n):
            dist[i][j] = np.linalg.norm(x[i] - x[j])
    return dist


def project(x, dtype = "data", niter = 50, delta_frac = 8):
    """
    Projection
    """
    assert type(x) is np.ndarray, \
        "*** ERROR (Force-Scheme): project input must be numpy.array type."
    
    ninst, dim = x.shape    # number of instances, dimension of the data
    
    Y = np.random.random((ninst, 2))    # random initialization

    # computes distance in R^n
    if dtype == "data":
        distRn = pdist(x)
    elif dtype == "dmat":
        distRn = x
    else:
        print "*** ERROR (Force-Scheme): Undefined data type."
    assert type(distRn) is np.ndarray and distRn.shape == (ninst, ninst), \
        "*** ERROR (Force-Scheme): project input must be numpy.array type."
    
    idx = np.random.permutation(ninst)

    for k in range(niter):
        # for each x'
        for i in range(ninst):
            inst1 = idx[i]
            # for each q' != x'
            for j in range(ninst):
                inst2 = idx[j]
                if inst1 != inst2:
                    # computes direction v
                    v = Y[inst2] - Y[inst1]
                    distR2 = np.hypot(v[0], v[1])
                    if distR2 < tol:
                        distR2 = tol
                    delta = (distRn[inst1][inst2] - distR2) / delta_frac
                    v /= distR2
                    # move q' = Y[j] in the direction of v by a fraction
                    # of delta
                    Y[inst2] += delta * v
    return Y


def plot(y, t):
    import matplotlib.pyplot as mpl
    mpl.scatter(y.T[0], y.T[1], c = t)
    mpl.show()

def test():
    import time, sys
    print "Loading data set... ",
    sys.stdout.flush()
    data = np.loadtxt("mammals.data", delimiter=",")
    print "Done."
    n, d = data.shape
    x = data[:, range(d-1)]
    t = data[:, d-1]
    start_time = time.time()
    print "Projecting... ",
    sys.stdout.flush()
    y = project(x)
    print "Done. Elapsed time:", time.time() - start_time, "s."
    plot(y, t)

if __name__ == "__main__":
    print "Running test..."
    test()


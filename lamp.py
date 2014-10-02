"""
LAMP
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


def project(x, xs, ys):
    """
    Projection
    """
    assert (type(x) is np.ndarray) and (type(xs) is np.ndarray) and (type(ys) is np.ndarray), \
        "*** ERROR (Force-Scheme): project input must be numpy.array type."

    ninst, dim = x.shape    # number os instances, data dimension
    k, a = xs.shape         # number os sample instances
    p = ys.shape[1]         # visual space dimension
    
    assert dim == a, "*** LAMP Error: x and xs dimensions must be egual."

    Y = np.zeros((ninst, p))
    for pt in range(ninst):
        # computes alphas
        alpha = np.zeros(k)
        for i in range(k):
            # verify if the point to be projectec is a control point
            # avoids division by zero
            if np.linalg.norm(xs[i] - x[pt]) < tol:
                alpha[i] = np.finfo(float).max
            else:
                alpha[i] = 1 / np.linalg.norm(xs[i] - x[pt])**2
        
        # computes x~ and y~ (eq 3)
        xtilde = np.zeros(dim)
        ytilde = np.zeros(p)
        for i in range(k):
            xtilde += alpha[i] * xs[i]
            ytilde += alpha[i] * ys[i]
        xtilde /= np.sum(alpha)
        ytilde /= np.sum(alpha)

        A = np.zeros((k, dim))
        B = np.zeros((k, p))
        xhat = np.zeros((k, dim))
        yhat = np.zeros((k, p))
        # computation of x^ and y^ (eq 6)
        for i in range(k):
            xhat[i] = xs[i] - xtilde
            yhat[i] = ys[i] - ytilde
            A[i] = np.sqrt(alpha[i]) * xhat[i]
            B[i] = np.sqrt(alpha[i]) * yhat[i]
    
        U, D, V = np.linalg.svd(np.dot(A.T, B)) # (eq 7)
        # VV is the matrix V filled with zeros
        VV = np.zeros((dim, p)) # size of U = dim, by SVD
        for i in range(p): # size of V = p, by SVD
             VV[i,range(p)] = V[i]
        
        M = np.dot(U, VV) # (eq 7)

        Y[pt] = np.dot(x[pt] - xtilde, M) + ytilde # (eq 8)

    return Y
    

def plot(y, t):
    import matplotlib.pyplot as mpl
    mpl.scatter(y.T[0], y.T[1], c = t)
    mpl.show()

def test():
    import time, sys, force
    print "Loading data set... ",
    sys.stdout.flush()
    data = np.loadtxt("iris.data", delimiter=",")
    print "Done."
    n, d = data.shape
    k = int(np.ceil(np.sqrt(n)))
    x = data[:, range(d-1)]
    t = data[:, d-1]
    sample_idx = np.random.permutation(n)
    sample_idx = sample_idx[range(k)]
    xs = x[sample_idx, :]
    # force
    start_time = time.time()
    print "Projecting samples... ",
    sys.stdout.flush()
    ys = force.project(xs)
    print "Done. Elapsed time:", time.time() - start_time, "s."
    # lamp
    start_time = time.time()
    print "Projecting... ",
    sys.stdout.flush()
    y = project(x, xs, ys)
    print "Done. Elapsed time:", time.time() - start_time, "s."
    plot(y, t)

if __name__ == "__main__":
    print "Running test..."
    test()


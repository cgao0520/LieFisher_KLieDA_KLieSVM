function k = kernel(ker, a, b, sig)
switch lower(ker)
    case 'rbf',
        d = norm(logm(inv(a)*b));
        k=exp(-d*d/sig);
        %k=exp(-d*d*0.9);
    case 'line'
        k = norm(a*b);
    case 'polym',
        k = (trace(b'*a) + 1 )^sig;
    case 'linear',
        k = trace(b'*a);
    case 'tanh',
        bb = 1/1000000000;
        c = 0;
        k = tanh(bb*(trace(b'*a)) - c);
    case 'sig',
        c = -1/1000000000;
        k = 1/( 1+exp(c*(trace(b'*a))) );
    otherwise,
end
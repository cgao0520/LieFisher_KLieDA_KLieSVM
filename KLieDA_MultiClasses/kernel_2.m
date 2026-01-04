function k = kernel(ker, a, b, sig)
switch lower(ker)
    case 'rbf',
        d = norm(logm(inv(a)*b));
        k=exp(-d*d/(2*sig*sig));
        %k=exp(-d*d*0.9);
    case 'polym',
        k = norm((a*b)^3);
    case 'polym2'
        k = (trace(b'*a))^3;
    otherwise,
end
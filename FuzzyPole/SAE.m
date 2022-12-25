

function z = SAE(x)

    global KE KCE KD KI
    KE = power(10,x(1));
    KCE = power(10,x(2));
    KD = power(10,x(3));
    KI = power(10,x(3));

    result = sim('pole');
    
    z = sum(abs(result.err));
    

end

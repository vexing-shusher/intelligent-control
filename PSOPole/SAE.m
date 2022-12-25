

function z = SAE(x)

    global P I D
    P = x(1);
    I = x(2);
    D = x(3);
    
    result = sim('pole');
    
    z = sum(abs(result.err));
    

end

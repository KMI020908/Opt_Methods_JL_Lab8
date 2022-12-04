function goldenAspMethod(func, ϕ, a, b, ϵ::Number = 1e-8)
    numOfFunctions::Int = 0; # Количество вычислений целевой функции

    τ = (1 + √5) / 2
    x1::Number = a + (1 - 1 / τ) * b
    x2::Number = a + b / τ

    funcStart1::Number = func(ϕ(x1)) 
    funcStart2::Number = func(ϕ(x2))
    numOfFunctions += 2

    gX1::Number = 0
    gX2::Number = 0

    previousFunc::Number = 0
    if funcStart1 < funcStart2
        b = x2
        previousFunc = funcStart1
        gX1 = x1
    else
        a = x1
        previousFunc = funcStart2
        gX1 = x2
    end
    gX2 = a + b - gX1

    if b - a < ϵ
        return (a + b) / 2
    end

    while b - a ≥ ϵ
        tempFunc::Number = func(ϕ(gX2))
        numOfFunctions += 1
        if gX2 < gX1
            x1 = gX2
            x2 = gX1
            if tempFunc < previousFunc
                b = x2
                previousFunc = tempFunc
                gX1 = x1
            else
                a = x1
                gX1 = x2
            end
        else
            x1 = gX1
            x2 = gX2
            if previousFunc < tempFunc
                b = x2
                gX1 = x1
            else
                a = x1
                previousFunc = tempFunc
                gX1 = x2
            end
        end
        gX2 = a + b - gX1
    end
    return (a + b) / 2, numOfFunctions 
end

function goldenAspMethod(func, a, b, point_prev::Vector{<:Number}, antiGrad::Vector{<:Number}, ϵ::Number)
    numOfFunctions::Int = 0; # Количество вычислений целевой функции

    τ = (1 + √5) / 2;
    x1::Number = a + (1 - 1 / τ) * b;
    x2::Number = a + b / τ;

    funcStart1::Number = func(point_prev + x1 * antiGrad); 
    funcStart2::Number = func(point_prev + x2 * antiGrad);
    numOfFunctions += 2;

    gX1::Number = 0;
    gX2::Number = 0;

    previousFunc::Number = 0;
    if funcStart1 < funcStart2
        b = x2;
        previousFunc = funcStart1;
        gX1 = x1;
    else
        a = x1;
        previousFunc = funcStart2;
        gX1 = x2;
    end
    gX2 = a + b - gX1;

    if b - a < ϵ
        return (a + b) / 2;
    end

    while b - a ≥ ϵ
        tempFunc::Number = func(point_prev + gX2 * antiGrad);
        numOfFunctions += 1;
        if gX2 < gX1
            x1 = gX2;
            x2 = gX1;
            if tempFunc < previousFunc
                b = x2;
                previousFunc = tempFunc;
                gX1 = x1;
            else
                a = x1;
                gX1 = x2;
            end
        else
            x1 = gX1;
            x2 = gX2;
            if previousFunc < tempFunc
                b = x2;
                gX1 = x1;
            else
                a = x1;
                previousFunc = tempFunc;
                gX1 = x2;
            end
        end
        gX2 = a + b - gX1;
    end
    return (a + b) / 2, numOfFunctions; 
end
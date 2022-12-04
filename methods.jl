import LinearAlgebra
import AutoGrad
import ForwardDiff
using LinearAlgebra
include("goldenAspMethod.jl")

function classicNewtonMethod(f, startPoint::Vector{<:Number}, ϵ::Number = 1e-6, η::Number = 1)
    numOfAntiGrad::Int = 0 # Количество вычислений антиградиента
    numOfFunctions::Int = 0 # Количество вычислений целевой функции
    X = Number[startPoint[1]]
    Y = Number[startPoint[2]]
    antiGradFunc(x) = -AutoGrad.grad(f)(x)
    hesseMatrix(x) = ForwardDiff.hessian(f, x)
    point = startPoint
    while norm(antiGradFunc(point)) ≥ ϵ
        hessian = hesseMatrix(point)
        while hessian[1, 1] <= 0 || det(hessian) <= 0 
            hessian[1, 1] += η
            hessian[2, 2] += η
        end
        numOfFunctions += 12 # Добавление числа вычислений функции
        numOfAntiGrad += 1 # Прибавление антиградиента
        numOfFunctions += 3 # Добавление числа вычислений функции
        point = point + hessian \ antiGradFunc(point)
        push!(X, point[1])
        push!(Y, point[2])
        if numOfAntiGrad == 10000
            break
        end
    end
    return point, f(point), numOfAntiGrad, numOfFunctions, X, Y, norm(antiGradFunc(point));
end;

function insideBarierMethod(f::Function, h::Function, r::Number, γ::Number, startPoint::Vector{<:Number}, ϵ::Float64 = 1e-6)
    numOfIterations::Int = 1; # Количество итераций
    numOfFunctions::Int = 0;
    X = Number[startPoint[1]] # Координаты x 
    Y = Number[startPoint[2]] # Координаты y
    f_k(x) = f(x) - r * h(x)
    prev_point = startPoint
    data = classicNewtonMethod(f_k, prev_point, ϵ)
    numOfFunctions += data[4]
    for i in 1 : length(data[5]) 
        push!(X, data[5][i])
    end
    for i in 1 : length(data[6]) 
        push!(Y, data[6][i])
    end
    point = data[1]
    prev_f = f(prev_point)
    r /= γ
    while abs(prev_f - data[2]) ≥ ϵ
        f_k_cycle(x) = f(x) - r * h(x)
        prev_point = point
        prev_f = data[2]
        data = classicNewtonMethod(f_k_cycle, prev_point, ϵ)
        numOfFunctions += data[4]
        for i in 1 : length(data[5]) 
            push!(X, data[5][i])
        end
        for i in 1 : length(data[6]) 
            push!(Y, data[6][i])
        end
        point = data[1]
        r /= γ
        numOfIterations += 1
    end
    return point, f(point), numOfFunctions, numOfIterations, X, Y
end;

function outsideBarierMethod(f::Function, h::Function, r::Number, γ::Number, startPoint::Vector{<:Number}, ϵ::Float64 = 1e-6)
    numOfIterations::Int = 1; # Количество итераций
    numOfFunctions::Int = 0;
    X = Number[startPoint[1]] # Координаты x 
    Y = Number[startPoint[2]] # Координаты y
    f_k(x) = f(x) - r * h(x)
    prev_point = startPoint
    data = classicNewtonMethod(f_k, prev_point, ϵ)
    numOfFunctions += data[4]
    for i in 1 : length(data[5]) 
        push!(X, data[5][i])
    end
    for i in 1 : length(data[6]) 
        push!(Y, data[6][i])
    end
    point = data[1]
    prev_f = f(prev_point)
    r += γ
    while abs(prev_f - data[2]) ≥ ϵ
        f_k_cycle(x) = f(x) + r * h(x)
        prev_point = point
        prev_f = data[2]
        data = classicNewtonMethod(f_k_cycle, prev_point, ϵ)
        numOfFunctions += data[4]
        for i in 1 : length(data[5]) 
            push!(X, data[5][i])
        end
        for i in 1 : length(data[6]) 
            push!(Y, data[6][i])
        end
        point = data[1]
        r += γ
        numOfIterations += 1
    end
    return point, f(point), numOfFunctions, numOfIterations, X, Y
end;




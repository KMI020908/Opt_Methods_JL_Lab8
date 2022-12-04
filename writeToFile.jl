function writeToFile(fileName::String, data, startPoint::Vector{<:Number}, ϵ::Number, f_string::String, 
    β0::Number = 0,  γ::Number = 0, ω::Number = 0)
    io::IO = open(fileName, "w");
    if (β0 ≠ 0) && (γ ≠ 0) 
        write(io, "β0 = " * string(β0),'\t', 
                "γ = " * string(γ),'\t',   
                "ω = " * string(ω),'\t', 
        "\n");
    end
    write(io, "Точность: ", string(ϵ), "\n");
    write(io, "Начальная точка: ", string(startPoint), "\n");
    write(io, "Минимальная точка: ", string(data[1]), "\n");
    write(io, "Минимальное значение: ", string(data[2]), "\n");
    write(io, "Количество итераций: ", string(data[4]), "\n");
    write(io, "Количество вычислений целевой функции: ", string(data[3]), "\n")
    close(io);
end;
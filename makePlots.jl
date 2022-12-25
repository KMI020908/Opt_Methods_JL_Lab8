using Plotly

function plotter(f, low, up, title = "")
    layout = Layout(
        title = attr(
            text = "<b>$title</b>", 
            font = attr(size = 25, family = "Times New Roman", color = "black")
        ),
        font=attr(
            family="Times New Roman",
            size=16
        )
    );
    x = range(low[1], stop = up[1], length = 100);
    y = range(low[2], stop = up[2], length = 100);
    z = [f([x[i], y[j]])
    for j in 1:100 for i in 1:100]
    z_ = [z[i:i+99] for i in 1:100:10000]
    data = Plotly.surface(
        z=z_, x=x, y=y, 
        colorscale = "Earth",
        contours_z=attr(
            show=true,
            usecolormap=true,
            project_z=true
        )
    )
    Plotly.Plot(data, layout)
end;

function makeGradPlot(f, low, up, X, Y, title = "", ϵ = 1e-6 , addBounds = 0, nc = 30, wd = 800, hg = 600)
    ϵ_string::String = string(ϵ)
    if ϵ == 0
        ϵ_string = "10⁻², 10⁻⁶"
    end
    layout = Layout(
        width = wd, height = hg,
        title = attr(
            text = "<b>$title, ϵ = $ϵ_string</b>", 
            font = attr(size = 25, family = "Times New Roman", color = "black")
        ),
        xaxis = attr(
            ticks="inside", tickwidth = 3, tickcolor = "black", ticklen = 10,
            showline = true, linewidth = 3, linecolor ="black", mirror = true, showticklabels = true,
            title_text = "<b>X</b>", title_font=attr(size = 18, family = "Times New Roman", color = "black"),
            range = [low[1], up[1]]
        ),
        yaxis = attr(
            ticks="inside", tickwidth = 3, tickcolor = "black", ticklen = 10,
            showline=true, linewidth = 3, linecolor = "black", mirror = true,
            title_text = "<b>Y</b>", title_font=attr(size=18, family = "Times New Roman", color = "black"),
            range = [low[2], up[2]]
        ),
        font=attr(
            family="Times New Roman",
            size=16
        )
    );
    #x = range(-0.5, stop = 3, length = 100);
    #y = range(0, stop = 4, length = 100);
    x = range(-30, stop = 30, length = 100);
    y = range(-30, stop = 30, length = 100);
    z = [f([x[i], y[j]])
    for i in 1:100 for j in 1:100];
    z_ = [z[i:i+99] for i in 1:100:10000];
    cntr = Plotly.contour(
        z = z_, 
        x = x, 
        y = y,
        colorscale = "Greens",
        contours = attr(
            showlabels = true,
        ),
        ncontours = nc
    )
    lineSctr = Plotly.scatter(
        x = X, 
        y = Y, 
        line=attr(color="DarkOrchid", width=4),
        showlegend = false
    )
    sctr = Plotly.scatter(
        x = [X[i] for i in 2:(length(X) - 1)], 
        y = [Y[i] for i in 2:(length(Y) - 1)],  
        mode = "markers",
        marker = attr(symbol = "circle", color = "orange", size = 6),
        showlegend = false
    )
    firstPoint = Plotly.scatter(
        x = [X[1]], y = [Y[1]], 
        marker = attr(symbol = "star-square-dot", color = "red", size = 10),
        showlegend = false
    )
    lastPoint = Plotly.scatter(
        x = [X[length(X)]], y = [Y[length(Y)]], 
        marker = attr(symbol = "x", color = "yellow", size = 12),
        showlegend = false
    )
    if addBounds == 1
        clr = "red"
        boundPl1 = Plotly.scatter(
            x = [0 for i in 0 : 0.1 : 10],
            y = [i for i in 0 : 0.1 : 10],
            line = attr(
                width = 4,
                color = clr,
                dash = "dash"
            ),
            showlegend = false
        )
        boundPl2 = Plotly.scatter(
            x = [i for i in 0 : 0.1 : 10],
            y = [0 for i in 0 : 0.1 : 10],
            line = attr(
                width = 4,
                color = clr,
                dash = "dash"
            ),
            showlegend = false
        )
        xInt = [i for i in 0 : 0.1 : 10]
        boundPl3 = Plotly.scatter(
            x = xInt,
            y = -xInt .+ 10,
            line = attr(
                width = 4,
                color = clr,
                dash = "dash"
            ),
            showlegend = false
        )
        return Plotly.Plot([cntr, lineSctr, sctr, firstPoint, lastPoint, boundPl1, boundPl2, boundPl3], layout)   
    end
    if addBounds == 2
        t = range(0, stop = 2 * π, length = 100)
        boundPl = Plotly.scatter( 
            x = 2 * √10 * cos.(t) .- 3,
            y = 3 * √10 * sin.(t) .- 4,
            line = attr(
                width = 4,
                color = "red",
                dash = "dash"
            ),
            showlegend = false
        )
        return Plotly.Plot([cntr, lineSctr, sctr, firstPoint, lastPoint, boundPl], layout)
    end
    return Plotly.Plot([cntr, lineSctr, sctr, firstPoint, lastPoint], layout)
end;

function makeGradPlotCustom(f, low, up, X, Y, title = "", ϵ = 1e-6 , addBounds = 0, wd = 800, hg = 600)
    layout = Layout(
        paper_bg = "white",
        width = wd, height = hg,
        title = attr(
            text = "<b>$title, ϵ = $ϵ</b>", 
            font = attr(size = 25, family = "Times New Roman", color = "black")
        ),
        xaxis = attr(
            ticks="inside", tickwidth = 3, tickcolor = "black", ticklen = 10,
            showline = true, linewidth = 3, linecolor ="black", mirror = true, showticklabels = true,
            title_text = "<b>X</b>", title_font=attr(size = 18, family = "Times New Roman", color = "black"),
        ),
        yaxis = attr(
            ticks="inside", tickwidth = 3, tickcolor = "black", ticklen = 10,
            showline=true, linewidth = 3, linecolor = "black", mirror = true,
            title_text = "<b>Y</b>", title_font=attr(size=18, family = "Times New Roman", color = "black"),
        ),
        font=attr(
            family="Times New Roman",
            size=16
        )
    );
    x = range(low[1], stop = up[1], length = 100);
    y = range(low[2], stop = up[2], length = 100);
    z = [f([x[i], y[j]])
    for i in 1:100 for j in 1:100];
    z_ = [z[i:i+99] for i in 1:100:10000];
    cntr = Plotly.contour(
        z = z_, 
        x = x, 
        y = y,
        autocontour = false,
        autoz = false,
        zmax = f([X[1], Y[1]]),
        zmin = f([X[length(X)] - 3, Y[length(Y)] - 3]),
        ncontours = 100
    )
    lineSctr = Plotly.scatter(
        x = X, 
        y = Y, 
        line=attr(color="black", width=6),
        showlegend = false
    )
    sctr = Plotly.scatter(
        x = [X[i] for i in 2:(length(X) - 1)], 
        y = [Y[i] for i in 2:(length(Y) - 1)],  
        mode = "markers",
        marker = attr(symbol = "circle", color = "orange", size = 8),
        showlegend = false
    )
    firstPoint = Plotly.scatter(
        x = [X[1]], y = [Y[1]], 
        marker = attr(symbol = "star-square-dot", color = "red", size = 12),
        showlegend = false
    )
    lastPoint = Plotly.scatter(
        x = [X[length(X)]], y = [Y[length(Y)]], 
        marker = attr(symbol = "x", color = "yellow", size = 12),
        showlegend = false
    )
    if addBounds == 1
        clr = "red"
        boundPl1 = Plotly.scatter(
            x = [0 for i in 0 : 0.1 : 10],
            y = [i for i in 0 : 0.1 : 10],
            line = attr(
                width = 4,
                color = clr,
                dash = "dash"
            ),
            showlegend = false
        )
        boundPl2 = Plotly.scatter(
            x = [i for i in 0 : 0.1 : 10],
            y = [0 for i in 0 : 0.1 : 10],
            line = attr(
                width = 4,
                color = clr,
                dash = "dash"
            ),
            showlegend = false
        )
        xInt = [i for i in 0 : 0.1 : 10]
        boundPl3 = Plotly.scatter(
            x = xInt,
            y = -xInt .+ 10,
            line = attr(
                width = 4,
                color = clr,
                dash = "dash"
            ),
            showlegend = false
        )
        return Plotly.Plot([cntr, lineSctr, sctr, firstPoint, lastPoint, boundPl1, boundPl2, boundPl3], layout)   
    end
    if addBounds == 2
        t = range(0, stop = 2 * π, length = 100)
        boundPl = Plotly.scatter( 
            x = 2 * √10 * cos.(t) .- 3,
            y = 3 * √10 * sin.(t) .- 4,
            line = attr(
                width = 4,
                color = "red",
                dash = "dash"
            ),
            showlegend = false
        )
        return Plotly.Plot([cntr, lineSctr, sctr, firstPoint, lastPoint, boundPl], layout)
    end
    return Plotly.Plot([cntr, lineSctr, sctr, firstPoint, lastPoint], layout)
end;
Sub cardsCheck()
    
    ' Declaración de variables
    Dim y, v_y_card As Integer ' Variables de posición sobre la tabla
    Dim v_open, v_close As Double ' Variables de valor de apertura y cierre
    Dim y_change, p_change, stockVol As Double ' Variables para guardar los valores calculados de Yearly change, Percent change y Total Stock Volume
    Dim great_inc, great_dec, great_tot_vol As Double
    Dim great_inc_name, great_dec_name, great_tot_vol_name As String
    
    ' Ciclo para realizar la acción en cada hoja
    Dim hojas As Integer
    hojas = Worksheets.Count
    For hh = 1 To hojas
    Worksheets.Item(hh).Select
    
    
    ' Inmoviliza paneles para poder leer mejor
    Range("A2").Select
    ActiveWindow.FreezePanes = True
    
    ' Pone títulos de columnas de resumen
    Range("I1").Value = "Ticker"
    Range("J1").Value = "Yearly change"
    Range("K1").Value = "Percent change"
    Range("L1").Value = "Total Stock Volume"
    
    'Inicialización de variables de posición
    v_y_card = 2
    y = 2
    
    ' Inicialización de variables TOP
    great_inc = 0
    great_dec = 0
    great_tot_vol = 0
    
    ' Set de valores iniciales
    Cells(v_y_card, 9).Value = Cells(y, 1).Value
    v_open = Cells(y, 3).Value
    stockVol = 0

    'Ciclo: Mientras el valor de la celda a revisar sea diferente de vacío, realizar acción
    While Cells(y, 1).Value <> ""
        
        ' Suma el volumen de stocks del renglón revisado al total de stocks
        stockVol = stockVol + Cells(y, 7).Value
        
        'Condición: Si el Ticker cambia en el siguiente renglón, realiza la acción
        If Cells(y, 1).Value <> Cells(y + 1, 1).Value Then
            
            ' Pone el valor de la suma de stocks totales para el ticker
            Cells(v_y_card, 12).Value = stockVol
            
            ' Obtiene el valor de cierre para el ticker
            v_close = Cells(y, 6).Value
            
            ' Calcula el valor del Yearly change restando el valor del cierre de año menos el valor de apertura de año
            y_change = v_close - v_open
            
            ' Condición, si el valor de apertura es cero asigna crecimiento de 100%, de otro modo hace el cálculo, esto es para evitar un error con divisiones entre cero
            If v_open <> 0 Then
                p_change = (v_close / v_open) - 1
            Else
                p_change = 1
            End If
            
            ' Pone los valores de Yearly change y Percent change calculados para el ticker
            Cells(v_y_card, 10).Value = y_change
            Cells(v_y_card, 11).Value = p_change
            
            ' Guarda los valores de mayor incremento, decremento y stock
            
            If stockVol > great_tot_vol Then
                great_tot_vol = stockVol
                great_tot_vol_name = Cells(v_y_card, 9).Value
            End If
            
            If p_change > great_inc Then
                great_inc = p_change
                great_inc_name = Cells(v_y_card, 9).Value
            End If
            
            If p_change < great_dec Then
                great_dec = p_change
                great_dec_name = Cells(v_y_card, 9).Value
            End If
            
            
            ' Avanza la variable de posición de la hoja resumen al siguiente renglón
            v_y_card = v_y_card + 1
            
            ' Reinicializa las variables para el siguiente ticker
            Cells(v_y_card, 9).Value = Cells(y + 1, 1).Value
            stockVol = 0
            v_open = Cells(y + 1, 3).Value
        
        End If
        
        ' Avanza la variable de posición de la hoja de datos al siguiente renglón
        y = y + 1
        
    Wend
    
    ' Pone formato de porcentaje a la columna de Percent change
    Columns("K:K").Select
    Selection.Style = "Percent"
    
    ' Pone formato condicional a la columna Yearly change, verde para mayor a cero y rojo para menor a cero
        Columns("J:J").Select
    Selection.FormatConditions.Add Type:=xlCellValue, Operator:=xlGreater, _
        Formula1:="=0"
    Selection.FormatConditions(Selection.FormatConditions.Count).SetFirstPriority
    With Selection.FormatConditions(1).Font
        .Color = -16752384
        .TintAndShade = 0
    End With
    With Selection.FormatConditions(1).Interior
        .PatternColorIndex = xlAutomatic
        .Color = 13561798
        .TintAndShade = 0
    End With
    Selection.FormatConditions(1).StopIfTrue = False
    Selection.FormatConditions.Add Type:=xlCellValue, Operator:=xlLess, _
        Formula1:="=0"
    Selection.FormatConditions(Selection.FormatConditions.Count).SetFirstPriority
    With Selection.FormatConditions(1).Font
        .Color = -16383844
        .TintAndShade = 0
    End With
    With Selection.FormatConditions(1).Interior
        .PatternColorIndex = xlAutomatic
        .Color = 13551615
        .TintAndShade = 0
    End With
    Selection.FormatConditions(1).StopIfTrue = False
    
    ' Inserta cuadro de valores TOP
    Range("N2").Value = "Greatest % Increase"
    Range("N3").Value = "Greatest % Decrease"
    Range("N4").Value = "Greatest Total Volume"
    
    Range("O1").Value = "Ticker"
    Range("P1").Value = "Value"
    
    Range("O2").Value = great_inc_name
    Range("P2").Value = great_inc
    Range("P2").Style = "Percent"
    
    Range("O3").Value = great_dec_name
    Range("P3").Value = great_dec
    Range("P3").Style = "Percent"
    
    Range("O4").Value = great_tot_vol_name
    Range("P4").Value = great_tot_vol
    
    ' Cierre de ciclo que realiza la acción en cada hoja
    Next hh
    
End Sub
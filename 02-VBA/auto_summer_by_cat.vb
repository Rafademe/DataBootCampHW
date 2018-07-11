'Calling Subroutine
Sub auto_summer_by_cat()

'Declaring variables.
 Dim ticker As String

 Dim sum As Double
 sum = 0

 Dim Summary_Table_Row As Integer
 Summary_Table_Row = 2

' Enter the range you want to sum over
 For i = 2 To 797711

 'column 1 is "ticker, column 7 is "Volume", column 8 is "ticker Name", column 9 is "ticker Sum".
 'As you can see, you need to change the column settings for different datasets.
     If Cells(i + 1, 1).Value <> Cells(i, 1).Value Then

         ticker = Cells(i, 1).Value
       
         sum = sum + Cells(i, 7).Value
       
         Range("I" & Summary_Table_Row).Value = ticker
       
         Range("J" & Summary_Table_Row).Value = sum
       
         Summary_Table_Row = Summary_Table_Row + 1
       
         sum = 0
       
     Else
   
         sum = sum + Cells(i, 7).Value
       
     End If
   
 Next i

End Sub
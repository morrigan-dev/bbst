program dprSortAlgo;

uses
  Forms,
  unitMain in 'unitMain.pas' {frmSortAlgo},
  unitBubbleSort in 'unitBubbleSort.pas',
  unitTypes in 'unitTypes.pas',
  unitMainModel in 'unitMainModel.pas',
  unitQuickSort in 'unitQuickSort.pas',
  unitSelectionSort in 'unitSelectionSort.pas',
  unitInsertionSort in 'unitInsertionSort.pas',
  unitShakerSort in 'unitShakerSort.pas',
  unitAbstractSort in 'unitAbstractSort.pas',
  unitHeapSort in 'unitHeapSort.pas',
  unitInfoBox in 'unitInfoBox.pas' {frmInfoBox};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmSortAlgo, frmSortAlgo);
  Application.CreateForm(TfrmInfoBox, frmInfoBox);
  Application.Run;
end.

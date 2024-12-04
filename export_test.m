%Daten auswählen
data_to_export = [aedb.aoa(:), aedb.aero.Cf_wX(:)]; % Spaltenweise Anordnung

%Daten in .csv speichern
csv_filename = 'output.csv';
writematrix(data_to_export, csv_filename);
disp(['Datei wurde gespeichert als: ', csv_filename]);

data_table = table(aedb.aoa(:), aedb.aero.Cf_wX(:), 'VariableNames', {'X', 'Y'});
writetable(data_table, 'output_with_headers.csv');
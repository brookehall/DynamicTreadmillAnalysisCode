function events = edit_events(events,fig)
    answer = questdlg('Do you want to add or delete an event?','Change events',"Add","Delete","All done","All done");
    list = {"RHS","LHS","RTO","LTO"};
    while answer~="All done"
        cursor_obj = datacursormode(fig);
        cursor_info = getCursorInfo(cursor_obj);
        [whichevent,~] = listdlg('PromptString','Which event do you want to add?','SelectionMode','single','ListString',list);
        if answer == "Add"
            if list{whichevent} == "RHS"
                events.rhs(length(events.rhs)+1,1) = cursor_info.Position(1,1);
            elseif list{whichevent} == "LHS"
                events.lhs(length(events.lhs)+1,1) = cursor_info.Position(1,1);
            elseif list{whichevent} == "RTO"
                events.rto(length(events.rto)+1,1) = cursor_info.Position(1,1);
            else
                events.lto(length(events.lto)+1,1) = cursor_info.Position(1,1);
            end
        elseif answer == "Delete"
            if list{whichevent} == "RHS"
                events.rhs(events.rhs==cursor_info.Position(1,1))=[];
            elseif list{whichevent} == "LHS"
                events.lhs(events.lhs==cursor_info.Position(1,1))=[];
            elseif list{whichevent} == "RTO"
                events.rto(events.rto==cursor_info.Position(1,1))=[];
            else
                events.lto(events.lto==cursor_info.Position(1,1))=[];
            end
        end
        disp({answer,'Frame',num2str(cursor_info.Position(1,1))})
        pause;
        answer = questdlg('Do you want to add or delete an event?','Change events',"Add","Delete","All done","All done");
    end
    events.rhs = sort(events.rhs); events.rto = sort(events.rto); 
    events.lhs = sort(events.lhs); events.lto = sort(events.lto); 
end

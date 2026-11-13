function [  ] = SendTrigger(tval)


outportb(888, tval); wait(20); outportb(888, 0);


end


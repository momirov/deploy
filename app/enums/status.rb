class Status < ClassyEnum::Base
end

class Status::New < Status
end

class Status::Running < Status
end

class Status::Completed < Status
end

class Status::Error < Status
end

class Status::Canceled < Status
end
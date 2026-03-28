---@meta

---@class FLiveLinkPropertyData
---@field PropertyName FName
---@field FloatChannel TArray<FMovieSceneFloatChannel>
---@field StringChannel TArray<FMovieSceneStringChannel>
---@field IntegerChannel TArray<FMovieSceneIntegerChannel>
---@field BoolChannel TArray<FMovieSceneBoolChannel>
---@field ByteChannel TArray<FMovieSceneByteChannel>
local FLiveLinkPropertyData = {}



---@class FLiveLinkSubSectionData
---@field Properties TArray<FLiveLinkPropertyData>
local FLiveLinkSubSectionData = {}



---@class FMovieSceneLiveLinkSectionTemplate : FMovieScenePropertySectionTemplate
---@field SubjectPreset FLiveLinkSubjectPreset
---@field ChannelMask TArray<boolean>
---@field SubSectionsData TArray<FLiveLinkSubSectionData>
local FMovieSceneLiveLinkSectionTemplate = {}



---@class UMovieSceneLiveLinkSection : UMovieSceneSection
---@field SubjectPreset FLiveLinkSubjectPreset
---@field ChannelMask TArray<boolean>
---@field SubSections TArray<UMovieSceneLiveLinkSubSection>
---@field SubjectName FName
---@field TemplateToPush FLiveLinkFrameData
---@field RefSkeleton FLiveLinkRefSkeleton
---@field CurveNames TArray<FName>
---@field PropertyFloatChannels TArray<FMovieSceneFloatChannel>
local UMovieSceneLiveLinkSection = {}



---@class UMovieSceneLiveLinkSubSection : UObject
---@field SubSectionData FLiveLinkSubSectionData
---@field SubjectRole TSubclassOf<ULiveLinkRole>
local UMovieSceneLiveLinkSubSection = {}



---@class UMovieSceneLiveLinkSubSectionAnimation : UMovieSceneLiveLinkSubSection
local UMovieSceneLiveLinkSubSectionAnimation = {}


---@class UMovieSceneLiveLinkSubSectionBasicRole : UMovieSceneLiveLinkSubSection
local UMovieSceneLiveLinkSubSectionBasicRole = {}


---@class UMovieSceneLiveLinkSubSectionProperties : UMovieSceneLiveLinkSubSection
local UMovieSceneLiveLinkSubSectionProperties = {}


---@class UMovieSceneLiveLinkTrack : UMovieScenePropertyTrack
---@field TrackRole TSubclassOf<ULiveLinkRole>
local UMovieSceneLiveLinkTrack = {}




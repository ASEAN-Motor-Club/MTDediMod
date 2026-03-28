---@meta

---@class FMovieSceneNiagaraCacheParams : FMovieSceneBaseCacheParams
---@field CacheParameters FNiagaraSimCacheCreateParameters
---@field SimCache UNiagaraSimCache
---@field bLockCacheToReadOnly boolean
---@field bOverrideQualityLevel boolean
---@field RecordQualityLevel EPerQualityLevels
---@field CacheReplayPlayMode ENiagaraSimCacheSectionPlayMode
---@field SectionStretchMode ENiagaraSimCacheSectionStretchMode
local FMovieSceneNiagaraCacheParams = {}



---@class FMovieSceneNiagaraCacheSectionTemplate : FMovieSceneTrackImplementation
---@field CacheSections TArray<FMovieSceneNiagaraSectionTemplateParameter>
local FMovieSceneNiagaraCacheSectionTemplate = {}



---@class FMovieSceneNiagaraSectionTemplateParameter
---@field SectionRange FMovieSceneFrameRange
---@field Params FMovieSceneNiagaraCacheParams
local FMovieSceneNiagaraSectionTemplateParameter = {}



---@class UMovieSceneNiagaraCacheSection : UMovieSceneBaseCacheSection
---@field Params FMovieSceneNiagaraCacheParams
---@field bCacheOutOfDate boolean
local UMovieSceneNiagaraCacheSection = {}



---@class UMovieSceneNiagaraCacheTrack : UMovieSceneNameableTrack
---@field bIsRecording boolean
---@field AnimationSections TArray<UMovieSceneSection>
---@field bCacheRecordingEnabled boolean
local UMovieSceneNiagaraCacheTrack = {}




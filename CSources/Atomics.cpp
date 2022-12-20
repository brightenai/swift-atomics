//
//  noarc.cpp
//  distance
//
//  Created by John Burkey on 8/10/21.
//

#define NOARC 1
//#define DEBUGTHREADS 1

#include <stdlib.h>
#include <stdio.h>
#include <list>
#include <thread>
#include <unordered_set>
#include <unordered_map>

//static void hook_swift_retain();

//size_t swift_retainCount(void *);
///----

#include <stdlib.h>
#include <stdio.h>
#include <string>

#define _Bool bool

extern "C"
{
extern int markedNoArc(void *object);

void brighten_StartNoArc();
extern int activeNoArc(const char* classname, size_t len);
void brighten_MarkNoArc(void *object);

void begin_DebuggingARC();
void end_DebuggingARC();

typedef void HeapObject;
typedef void HeapMetadata;

extern void *(*_swift_retain)(void *);
extern void *(*_swift_release)(void *);
extern void *(*_swift_retain_n)(void *, uint32_t);

extern HeapObject *(*_swift_allocObject)(HeapMetadata const *metadata,
                                             size_t requiredSize,
                                             size_t requiredAlignmentMask);

static bool sNoArcActive = false;
static void *(*_old_swift_retain)(void*);
static void *(*_old_swift_release)(void*);
static void *(*_old_swift_allocObject)(void const*,size_t,size_t);

size_t swift_retainCount(void *);
const char *swift_getTypeName(void *classObject, _Bool qualified);

void addClassNameToNoArc( const char* name);

}

typedef uintptr_t __swift_uintptr_t;
    
typedef struct {
  __swift_uintptr_t refCounts;
} InlineRefCountsPlaceholder;

typedef InlineRefCountsPlaceholder InlineRefCounts;

#define SWIFT_HEAPOBJECT_NON_OBJC_MEMBERS       \
  InlineRefCounts refCounts

#ifndef __ptrauth_objc_isa_pointer
   #define __ptrauth_objc_isa_pointer
    #endif

static std::unordered_map<std::string,std::string>* valuesDict = new std::unordered_map<std::string,std::string>();
static std::unordered_set<int>* classesNoArcDict = new std::unordered_set<int>();

typedef struct
{
    uint32_t isa;
//    uint32_t a;
//    uint32_t b;
//    uint32_t c;
//    uint32_t d;
//    uint32_t e;
//    uint32_t f;

} HeapMetadataX;

struct HeapObjectX
{
    HeapMetadataX const *__ptrauth_objc_isa_pointer metadata;

    SWIFT_HEAPOBJECT_NON_OBJC_MEMBERS;


};


static std::string* noArc = new std::string("NoArc");

static bool debugging = false;

static std::thread::id* debuggingThread = NULL;
static std::thread::id debuggingThreadX = std::this_thread::get_id();
static int releasesForDebugging = 0;

void begin_DebuggingARC()
{
#if DEBUGTHREADS
    debuggingThreadX = std::this_thread::get_id();
    debuggingThread = &debuggingThreadX;
    debugging = true;
    releasesForDebugging = 0;
#endif
}

void end_DebuggingARC()
{
#if DEBUGTHREADS
    debuggingThread = NULL;

    debugging = false;

    if (releasesForDebugging > 0)
    {
        fprintf(stderr, "end_DebuggingARC, cheap releases %d\n", (int) releasesForDebugging);
    }
#endif
}

static void report()
{
    fprintf(stderr, "");
}

static void *swift_retain_hook(void *object) {
    
    if (object)
    {
        if (classesNoArcDict->find(((HeapMetadataX*) *(void**)object)->isa) != classesNoArcDict->end())
        {
            return object;
        }


#if DEBUGTHREADS
          std::thread::id* dt = debuggingThread;
        if (debugging) //(dt != NULL && *dt == std::this_thread::get_id())
        {
        void *isa = *(void**)object;
        HeapMetadataX* guessing = (HeapMetadataX*) isa;
            
        const char *className = swift_getTypeName(isa, 0);
        fprintf(stderr, "full retain for %s %x \n", className,guessing->isa);
        report();
            
        }
#endif
    }
    else
    {
        return NULL;
    }

    return _old_swift_retain(object);
}

static void *swift_release_hook(void *object) {
    if (object)
    {
        if (classesNoArcDict->find(((HeapMetadataX*) *(void**)object)->isa) != classesNoArcDict->end())
        {
            return object;
        }

#if DEBUGTHREADS
          std::thread::id* dt = debuggingThread;
        if (debugging) //(dt != NULL && *dt == std::this_thread::get_id())
        {
        void *isa = *(void**)object;
        HeapMetadataX* guessing = (HeapMetadataX*) isa;
            
        const char *className = swift_getTypeName(isa, 0);
        fprintf(stderr, "full release for %s %x \n", className,guessing->isa);
        report();
            
        }
#endif
    }
    else
    {
        return NULL;
    }
    
    return _old_swift_release(object);
}


void addClassNameToNoArc( const char* name)
{
    std::string classNameA(name);
    
    valuesDict->insert(std::pair<std::string, std::string>(classNameA, classNameA));
}

void brighten_MarkNoArc(void *object)
{
#if NOARC
    if (classesNoArcDict->find(((HeapMetadataX*) *(void**)object)->isa) == classesNoArcDict->end())
    {
//#if DEBUGTHREADS
//        void *isa = *(void**)object;
//        HeapMetadataX* guessingX = (HeapMetadataX*) *(void**)object;
//            const char *className = swift_getTypeName(isa, 0);
//            fprintf(stderr, "mark no arc for %s %x\n", className,guessingX->isa);
//#endif
        HeapMetadataX* guessing = (HeapMetadataX*) *(void**)object;
//        if (!classesNoArcDict->count(((HeapMetadataX*) *(void**)object)->isa) > 0)
//        {
            classesNoArcDict->insert(guessing->isa);   // You could mark classes this way and use a lock
//        }
    }
#endif
}

// this is like static init for dylibs..
//__attribute__((constructor))
void brighten_StartNoArc() {
#if NOARC
    if (!sNoArcActive)
    {
        sNoArcActive = true;
        _old_swift_retain = _swift_retain;
        _swift_retain = swift_retain_hook;
        
        _old_swift_release = _swift_release;
        _swift_release = swift_release_hook;
    }
#endif
    
//    _old_swift_allocObject = _swift_allocObject;
//    _swift_allocObject = swift_allocObject_Hook;

//    std::string NoArc("NoArc");

}


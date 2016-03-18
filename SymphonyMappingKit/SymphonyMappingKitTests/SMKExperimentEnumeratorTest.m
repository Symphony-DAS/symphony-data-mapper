//
//  SMKExperimentEnumeratorTest.m
//  
//
//  Created by Mark Cafaro on 3/16/16.
//
//

#import "SMKBaseTestCase.h"
#import "SMKExperimentEnumerator.h"
#import "SMKExperiment.h"
#import "SMKDeviceEnumerator.h"
#import "SMKSourceEnumerator.h"
#import "SMKEpochGroupEnumerator.h"
#import "MACHdf5Reader.h"

@interface SMKExperimentEnumeratorTest : SMKBaseTestCase {
    SMKExperimentEnumerator *_enumerator;
}

@end

@implementation SMKExperimentEnumeratorTest

- (void)setUp {
    [super setUp];
    
    MACHdf5Reader *reader = [MACHdf5Reader readerWithFilePath:[_resourcePath stringByAppendingString:@"2016-03-16.h5"]];
    
    NSString *experiment = @"/experiment-ed6102df-f6c0-4ce0-81d9-4dae15dbe468";
    
    _enumerator = [[[SMKExperimentEnumerator alloc] initWithReader:reader experimentPaths:[NSArray arrayWithObjects:experiment, nil]] autorelease];
}

- (void)testNextObject
{
    int i = 0;
    while ([_enumerator nextObject]) {
        i++;
    }
    STAssertTrue(i == 1, nil);
}

- (void)testPurpose
{
    SMKExperiment *experiment = [_enumerator nextObject];
    
    STAssertTrue([experiment.purpose isEqualToString:@"my purpose here"], nil);
}

- (void)testStartTime
{
    SMKExperiment *experiment = [_enumerator nextObject];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss Z"];
    
    STAssertTrue([[dateFormatter stringFromDate:experiment.startTime] isEqualToString:@"2016-03-16 13:19:19 -0700"], nil);
}

- (void)testEndTime
{
    SMKExperiment *experiment = [_enumerator nextObject];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss Z"];
    
    STAssertTrue([[dateFormatter stringFromDate:experiment.endTime] isEqualToString:@"2016-03-16 13:25:39 -0700"], nil);
}

- (void)testProperties
{
    SMKExperiment *experiment = [_enumerator nextObject];
    
    NSDictionary *expected = [NSDictionary dictionaryWithObjectsAndKeys:
                              @"Mark Cafaro", @"experimenter",
                              @"Awesome project", @"project",
                              @"UW", @"institution",
                              @"Rieke lab", @"lab",
                              @"ed6102df-f6c0-4ce0-81d9-4dae15dbe468", @"__symphony__uuid__",
                              nil];
    
    STAssertTrue([experiment.properties isEqualToDictionary:expected], nil);
}

- (void)testKeywords
{
    SMKExperiment *experiment = [_enumerator nextObject];
    
    STAssertTrue([experiment.keywords count] == 0, nil);
}

- (void)testDeviceEnumerator
{
    SMKExperiment *experiment = [_enumerator nextObject];
    
    SMKDeviceEnumerator *deviceEnumerator = experiment.deviceEnumerator;
    
    int i = 0;
    while ([deviceEnumerator nextObject]) {
        i++;
    }
    STAssertTrue(i == 6, nil);
}

- (void)testSourceEnumerator
{
    SMKExperiment *experiment = [_enumerator nextObject];
    
    SMKSourceEnumerator *sourceEnumerator = experiment.sourceEnumerator;
    
    int i = 0;
    while ([sourceEnumerator nextObject]) {
        i++;
    }
    STAssertTrue(i == 1, nil);
}

- (void)testEpochGroupEnumerator
{
    SMKExperiment *experiment = [_enumerator nextObject];
    
    SMKEpochGroupEnumerator *groupEnumerator = experiment.epochGroupEnumerator;
    
    int i = 0;
    while ([groupEnumerator nextObject]) {
        i++;
    }
    STAssertTrue(i == 2, nil);
}

@end

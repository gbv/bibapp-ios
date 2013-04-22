//
//  BAItem.m
//  bibapp
//
//  Created by Johannes Schultze on 28.10.12.
//  Copyright (c) 2012 Johannes Schultze. All rights reserved.
//

#import "BAEntryWork.h"

@implementation BAEntryWork

@synthesize title;
@synthesize subtitle;
@synthesize infoText;
@synthesize ppn;
@synthesize matstring;
@synthesize matcode;
@synthesize local;
@synthesize canRenewCancel;
@synthesize item;
@synthesize edition;
@synthesize bar;
@synthesize label;
@synthesize date;
@synthesize queue;
@synthesize renewal;
@synthesize storage;
@synthesize onlineLocation;
@synthesize toc;
@synthesize tocArray;
@synthesize author;
@synthesize selected;
@synthesize mediaIconPhysicalDescriptionForm;
@synthesize mediaIconTypeOfResourceManuscript;
@synthesize mediaIconTypeOfResource;
@synthesize mediaIconRelatedItemType;
@synthesize mediaIconDisplayLabel;
@synthesize mediaIconOriginInfoIssuance;
@synthesize partName;
@synthesize partNumber;

- (UIImage *)mediaIcon
{
    /*
     $mediatype = "X"
     
     if <physicalDescription><form>microform</form></physicalDescription>
        $mediatype = "E" # Mikroform
     
     elseif <typeOfResource manuscript="yes">
        $mediatype = "H" # Manuskript (Handschrift)
     
     elseif <relatedItem type="host" displayLabel="In: "/>
        $mediatype = "A" # Aufsatz
     
     else
        case <typeOfResource>
     
        ::still image
            $mediatype = "I" # Foto
     
        ::sound recording-musical
            $mediatype = "G" # Tonträger
     
        ::sound recording-nonmusical
            $mediatype = "G" # Tonträger
     
        ::sound recording
            $mediatype = "G" # Tonträger
     
        ::cartographic
            $mediatype = "K" # Karte
     
        ::notated music
            $mediatype = "M" # Noten
     
        ::moving image
            $mediatype = "V" # Film / Video
     
        ::text
            if <originInfo><issuance>serial || continuing
                $mediatype = "T" # Zeitschrift
            else
                $mediatype = "B" # Monographie (Buch)
     
        ::software, multimedia
            if <originInfo><issuance>serial || continuing
                if <physicalDescription><form>remote
                    $mediatype = "P" # Online Zeitschrift
                else
                    $mediatype = "T" # Zeitschrift
            else
                if <physicalDescription><form>remote
                    $mediatype = "O" # Online-Ressource
                else
                    $mediatype = "S" # Datenträger
        end case
     */
    
    if ([self.matcode isEqualToString:@""] || self.matcode == nil) {
        [self setMatcode:@"mediaIconX.png"];
        if ([self.mediaIconPhysicalDescriptionForm isEqualToString:@"microform"]) {
            [self setMatcode:@"mediaIconE.png"];
        } else if ([self.mediaIconTypeOfResourceManuscript isEqualToString:@"yes"]) {
            [self setMatcode:@"mediaIconH.png"];
        } else if ([self.mediaIconRelatedItemType isEqualToString:@"host"] && [self.mediaIconDisplayLabel isEqualToString:@"In"]) {
            [self setMatcode:@"mediaIconA.png"];
        } else {
            if([self.mediaIconTypeOfResource isEqualToString:@"still image"]) {
                [self setMatcode:@"mediaIconI.png"];
            } else if([self.mediaIconTypeOfResource isEqualToString:@"sound recording-musical"]) {
                [self setMatcode:@"mediaIconG.png"];
            } else if([self.mediaIconTypeOfResource isEqualToString:@"sound recording-nonmusical"]) {
                [self setMatcode:@"mediaIconG.png"];
            } else if([self.mediaIconTypeOfResource isEqualToString:@"sound recording"]) {
                [self setMatcode:@"mediaIconG.png"];
            } else if([self.mediaIconTypeOfResource isEqualToString:@"cartographic"]) {
                [self setMatcode:@"mediaIconK.png"];
            } else if([self.mediaIconTypeOfResource isEqualToString:@"notated music"]) {
                [self setMatcode:@"mediaIconM.png"];
            } else if([self.mediaIconTypeOfResource isEqualToString:@"moving image"]) {
                [self setMatcode:@"mediaIconV.png"];
            } else if([self.mediaIconTypeOfResource isEqualToString:@"text"]) {
                if([self.mediaIconOriginInfoIssuance isEqualToString:@"serial"] || [self.mediaIconOriginInfoIssuance isEqualToString:@"continuing"]) {
                    [self setMatcode:@"mediaIconT.png"];
                } else {
                    [self setMatcode:@"mediaIconB.png"];
                }
            } else if([self.mediaIconTypeOfResource isEqualToString:@"software, multimedia"]) {
                if([self.mediaIconOriginInfoIssuance isEqualToString:@"serial"] || [self.mediaIconOriginInfoIssuance isEqualToString:@"continuing"]) {
                    if([self.mediaIconPhysicalDescriptionForm isEqualToString:@"remote"]) {
                        [self setMatcode:@"mediaIconP.png"];
                    } else {
                        [self setMatcode:@"mediaIconT.png"];
                    }
                } else {
                    if([self.mediaIconPhysicalDescriptionForm isEqualToString:@"remote"]) {
                        [self setMatcode:@"mediaIconO.png"];
                    } else {
                        [self setMatcode:@"mediaIconS.png"];
                    }
                }
            }
        }
    }
    return [UIImage imageNamed:self.matcode];
}

@end

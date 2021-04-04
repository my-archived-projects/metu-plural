//
//  MainViewController.m
//  Plural PoC
//
//  Created by Metehan Karabiber on 4/15/15.
//  Copyright (c) 2015 SM589 Term Project. All rights reserved.
//

#define MENU @[@"Processes", @"Roles", @"Modelling"]

@import QuartzCore;

#import "MainViewController.h"
#import "ProcessDefineVC.h"
#import "OperationDefineVC.h"
#import "RoleDefineVC.h"
#import "DesignerVC.h"

#import "Process.h"
#import "Operation.h"
#import "Role.h"

#define	  EXTERNALS @"AlreadyAddedExternals"

@interface MainViewController ()
- (IBAction) about:(id)sender;
- (IBAction) reset:(id)sender;

- (IBAction) addProcess:(id)sender;
- (IBAction) addOperation:(id)sender;
- (IBAction) addRole:(id)sender;
- (IBAction) createEditModel:(id)sender;

- (void) showTemporaryAlert:(NSString *)message;
@end

@implementation MainViewController

- (void) viewDidLoad {
	[super viewDidLoad];
}

- (IBAction) about:(id)sender {
	UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil
																   message:@"SM 589 - Metehan Karabiber\nCopyright © 2015"
															preferredStyle:UIAlertControllerStyleAlert];
	UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Dismiss"
															style:UIAlertActionStyleDefault
														  handler:^(UIAlertAction * action) {}];
	[alert addAction:defaultAction];
	[self presentViewController:alert animated:YES completion:nil];
}

- (IBAction) reset:(id)sender {
	UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Are you sure?"
																   message:@"Everything will be deleted!"
															preferredStyle:UIAlertControllerStyleAlert];
	[alert addAction:[UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleCancel handler:nil]];
	[alert addAction:[UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
		NSManagedObjectContext *ctx = [CoreDataContext getContext].managedObjectContext;
		
		for (NSManagedObject *o in [ctx executeFetchRequest:[[NSFetchRequest alloc] initWithEntityName:ROLE] error:NULL]) {
			[ctx deleteObject:o];
		}
		for (NSManagedObject *o in [ctx executeFetchRequest:[[NSFetchRequest alloc] initWithEntityName:ELEMENT] error:NULL]) {
			[ctx deleteObject:o];
		}
		for (NSManagedObject *o in [ctx executeFetchRequest:[[NSFetchRequest alloc] initWithEntityName:OPERATION] error:NULL]) {
			[ctx deleteObject:o];
		}
		for (NSManagedObject *o in [ctx executeFetchRequest:[[NSFetchRequest alloc] initWithEntityName:PROCESS] error:NULL]) {
			[ctx deleteObject:o];
		}

		NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
		[[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];

		[self showTemporaryAlert:@"The database is emptied!"];
	}]];
	[self presentViewController:alert animated:YES completion:NULL];
}

- (IBAction) addProcess:(id)sender {
	ProcessDefineVC *vc = [[ProcessDefineVC alloc] initWithNibName:@"ProcessDefineVC" bundle:nil];
	vc.modalPresentationStyle = UIModalPresentationFormSheet;
	[self presentViewController:vc animated:YES completion:NULL];
}

- (IBAction) addOperation:(id)sender {
	NSManagedObjectContext *ctx = [CoreDataContext getContext].managedObjectContext;
	NSFetchRequest *req = [[NSFetchRequest alloc] initWithEntityName:PROCESS];
	req.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];

	NSArray *processes = [ctx executeFetchRequest:req error:NULL];

	if (!processes || processes.count == 0) {
		UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil
																	   message:@"You must create at least 1 Process first!"
																preferredStyle:UIAlertControllerStyleAlert];
		[alert addAction:[UIAlertAction actionWithTitle:@"Dismiss"
												  style:UIAlertActionStyleDestructive
												handler:^(UIAlertAction * action) {}]];
		[self presentViewController:alert animated:YES completion:nil];
		return;
	}
	
	OperationDefineVC *vc = [[OperationDefineVC alloc] initWithNibName:@"OperationDefineVC" bundle:nil];
	vc.modalPresentationStyle = UIModalPresentationFormSheet;
	[self presentViewController:vc animated:YES completion:NULL];
}

- (IBAction) addRole:(id)sender {
	NSManagedObjectContext *ctx = [CoreDataContext getContext].managedObjectContext;
	NSFetchRequest *req = [[NSFetchRequest alloc] initWithEntityName:OPERATION];
	req.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
	
	NSArray *operations = [ctx executeFetchRequest:req error:NULL];

	if (!operations || operations.count == 0) {
		UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil
																	   message:@"You must create at least 1 Operation first!"
																preferredStyle:UIAlertControllerStyleAlert];
		[alert addAction:[UIAlertAction actionWithTitle:@"Dismiss"
												  style:UIAlertActionStyleDestructive
												handler:^(UIAlertAction * action) {}]];
		[self presentViewController:alert animated:YES completion:nil];
		return;
	}

	RoleDefineVC *vc = [[RoleDefineVC alloc] initWithNibName:@"RoleDefineVC" bundle:nil];
	vc.modalPresentationStyle = UIModalPresentationFormSheet;
	[self presentViewController:vc animated:YES completion:NULL];
}

- (IBAction) createEditModel:(id)sender {
	NSManagedObjectContext *ctx = [CoreDataContext getContext].managedObjectContext;
	NSFetchRequest *req = [[NSFetchRequest alloc] initWithEntityName:ROLE];
	req.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];

	NSArray *roles = [ctx executeFetchRequest:req error:NULL];

	if (!roles || roles.count == 0) {
		UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil
																	   message:@"You must create at least 1 Role first!"
																preferredStyle:UIAlertControllerStyleAlert];
		[alert addAction:[UIAlertAction actionWithTitle:@"Dismiss"
												  style:UIAlertActionStyleDestructive
												handler:^(UIAlertAction * action) {}]];
		[self presentViewController:alert animated:YES completion:nil];
		return;
	}
	
	UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Select Role"
																   message:@"Which 'Role' will perform modelling?"
															preferredStyle:UIAlertControllerStyleActionSheet];
    alert.modalPresentationStyle = UIModalPresentationPopover;
    alert.popoverPresentationController.sourceView = self.view;
    alert.popoverPresentationController.sourceRect = CGRectMake(567, 454, 386, 40);
	for (Role *r in roles) {
		[alert addAction:[UIAlertAction actionWithTitle:r.name
												  style:UIAlertActionStyleDefault
												handler:^(UIAlertAction * action) {
													[self showOperationSelectionMenu:r];
												}]];
	}
	[alert addAction:[UIAlertAction actionWithTitle:@"Cancel"
											  style:UIAlertActionStyleDestructive
											handler:^(UIAlertAction * action) {}]];
	
	[self presentViewController:alert animated:YES completion:nil];
}

- (void) showOperationSelectionMenu:(Role *)role {
	UIAlertController* alert;

	if (!role.operations || role.operations.count == 0) {
		alert = [UIAlertController alertControllerWithTitle:nil
													message:@"No operation is assigned for this role!"
											 preferredStyle:UIAlertControllerStyleAlert];
		[alert addAction:[UIAlertAction actionWithTitle:@"Dismiss"
												  style:UIAlertActionStyleDestructive
												handler:^(UIAlertAction * action) {}]];
	}
	else {
		alert = [UIAlertController alertControllerWithTitle:@"Select Operation"
													message:@"Which 'Operation' will you work on modelling?"
											 preferredStyle:UIAlertControllerStyleActionSheet];
        alert.modalPresentationStyle = UIModalPresentationPopover;
        alert.popoverPresentationController.sourceView = self.view;
        alert.popoverPresentationController.sourceRect = CGRectMake(567, 454, 386, 40);

		for (Operation *o in role.operations) {
			[alert addAction:[UIAlertAction actionWithTitle:o.name
													  style:UIAlertActionStyleDefault
													handler:^(UIAlertAction * action) {
														[self loadDesignerFor:o];
													}]];
		}
		[alert addAction:[UIAlertAction actionWithTitle:@"Cancel"
												  style:UIAlertActionStyleDestructive
												handler:^(UIAlertAction * action) {}]];
	}

	[self presentViewController:alert animated:YES completion:nil];
}

- (void) loadDesignerFor:(Operation *)operation {
	DesignerVC *vc = [[DesignerVC alloc] initWithNibName:@"DesignerVC" bundle:nil];
	vc.operation = operation;
	vc.modalPresentationStyle = UIModalPresentationOverFullScreen;
	[self presentViewController:vc animated:YES completion:NULL];
}

- (void) showTemporaryAlert:(NSString *)message {
	__block UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
	label.text = message;
	label.font = [UIFont boldSystemFontOfSize:16];
	label.backgroundColor = [UIColor blackColor];
	label.textColor = [UIColor whiteColor];
	label.textAlignment = NSTextAlignmentCenter;
	label.alpha = 0.5;
	[label sizeToFit];
	
	label.frame = CGRectMake(0, 0, label.frame.size.width + 20, label.frame.size.height + 16);
	label.center = self.view.center;
	label.layer.cornerRadius = 6;
	label.layer.masksToBounds = YES;
	[self.view addSubview:label];
	[self.view bringSubviewToFront:label];
	
	[UIView animateWithDuration:2.0
					 animations:^{
						 label.alpha = 1;
					 }
					 completion:^(BOOL finished) {
						 [UIView animateWithDuration:2.0 animations:^{
							 label.alpha = 0;
							}
										  completion:^(BOOL finished) {
											  [label removeFromSuperview];
											  label = nil;
										  }];
					 }
	 ];
}

@end

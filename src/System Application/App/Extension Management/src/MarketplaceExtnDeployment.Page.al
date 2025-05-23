// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------

namespace System.Apps;

using System.Globalization;

/// <summary>
/// Provides an interface for installing extensions from AppSource.
/// </summary>
page 2510 "Marketplace Extn Deployment"
{
    Extensible = false;
    Caption = 'Install extension';
    PageType = NavigatePage;
    ContextSensitiveHelpPage = 'ui-extensions';
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            field(ActiveUsers; ActiveUsersLbl)
            {
                ShowCaption = false;
                Editable = false;
                Style = Strong;
                ToolTip = 'There might be other users working in the system.';
            }
            field(Warning; WarningLbl)
            {
                ShowCaption = false;
                Editable = false;
                ToolTip = 'Installing extensions during business hours will disrupt other users.';
            }
            field(RefreshInfo; RefreshInfoLbl)
            {
                ShowCaption = false;
                Editable = false;
                ToolTip = 'After installation, your session will refresh, and you can set up your extension.';
            }
            field(PreviewInfo; PreviewInfoLbl)
            {
                ShowCaption = false;
                Editable = false;
                MultiLine = true;
                Style = Strong;
                ToolTip = 'You are about to install a preview version of the extension.';
                Visible = InstallPreview;
            }
            field(ImportantInfo; ImportantInfoLbl)
            {
                ShowCaption = false;
                Editable = false;
                Style = Strong;
            }
            field(ImportantDisclaimer; ImportantDisclaimerLbl)
            {
                ShowCaption = false;
                Editable = false;
                MultiLine = true;
                Style = None;
                ToolTip = 'Installing applications may require dependencies to be installed.';
            }
            field(HelpLink; InstallAppsURLLbl)
            {
                ShowCaption = false;
                ToolTip = 'Read more about installing and uninstalling apps.';
                Editable = false;
                MultiLine = true;
                Style = None;

                trigger OnDrillDown()
                begin
                    Hyperlink(InstallAppsURLLbl);
                end;
            }
            field(Language; LanguageName)
            {
                Caption = 'Language';
                ToolTip = 'Specifies the language of the extension.';
                Editable = false;

                trigger OnAssistEdit()
                var
                    Language: Codeunit Language;
                begin
                    Language.LookupApplicationLanguageId(LanguageID);
                    LanguageName := Language.GetWindowsLanguageName(LanguageID);
                end;
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Install)
            {
                Image = Approve;
                Caption = 'Install';
                ToolTip = 'Install the extension.';
                InFooterBar = true;

                trigger OnAction()
                begin
                    InstallSelected := true;

                    CurrPage.Close();
                    exit;
                end;
            }
        }
    }

    internal procedure GetLanguageId(): Integer
    begin
        exit(LanguageID);
    end;

    internal procedure GetInstalledSelected(): Boolean
    begin
        exit(InstallSelected);
    end;

    internal procedure SetAppID(ID: Guid)
    begin
        AppID := ID;
    end;

    internal procedure SetPreviewKey(PreviewKey: Text[2048])
    begin
        if (PreviewKey <> '') then
            InstallPreview := true;
    end;

    trigger OnInit()
    var
        LanguageManagement: Codeunit Language;
    begin
        LanguageID := GlobalLanguage();
        LanguageName := LanguageManagement.GetWindowsLanguageName(LanguageID);
        Clear(InstallSelected);
    end;

    trigger OnOpenPage()
    var
        DataOutOfGeoAppImpl: Codeunit "Data Out Of Geo. App Impl.";
    begin
        DataOutOfGeoAppImpl.CheckAndFireNotification(AppID);
    end;

    var
        LanguageName: Text;
        LanguageID: Integer;
        InstallSelected: Boolean;
        InstallPreview: Boolean;
        AppID: Guid;
        ActiveUsersLbl: Label 'Note: There might be other users working in the system.';
        WarningLbl: Label 'Installing extensions during business hours will disrupt other users.';
        ImportantInfoLbl: Label 'Important';
        ImportantDisclaimerLbl: Label 'When installing an AppSource app, it may require additional apps to be installed as dependencies. Make sure to review the provider''s terms of use and privacy policy review before proceeding. For more information on installing and uninstalling apps, see the link below.';
        RefreshInfoLbl: Label 'After installation, your session will refresh, and you can set up your extension.';
        PreviewInfoLbl: Label 'Note: A preview key was provided for the installation. A preview version of the extension is about to be installed. If a higher public version exists for your environment, it will be installed instead of the preview version.';
        InstallAppsURLLbl: Label 'https://go.microsoft.com/fwlink/?linkid=2260926', Locked = true;
}

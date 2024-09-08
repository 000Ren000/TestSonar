﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

Процедура Подключаемый_ПроверитьНаличиеНовойИнформацииВМонитореПортала1СИТС() Экспорт
	
	МониторПортала1СИТСКлиент.ПроверитьНаличиеНовойИнформацииВМонитореПортала1СИТС();
	
КонецПроцедуры

Процедура Подключаемый_ОткрытьМониторПортала1СИТССПодключениемИнтернетПоддержки() Экспорт
	
	ИнтернетПоддержкаПользователейКлиент.ПодключитьИнтернетПоддержкуПользователей(
		Новый ОписаниеОповещения("ПодключениеИнтернетПоддержкиПриНачалеРаботыЗавершение",
		МониторПортала1СИТСКлиент));
	
КонецПроцедуры

Процедура Подключаемый_ПроверитьНаличиеПредупрежденийВМонитореПортала1СИТС() Экспорт
	
	МониторПортала1СИТСКлиент.ПроверитьНаличиеПредупрежденийВМонитореПортала1СИТС();
	
КонецПроцедуры

#КонецОбласти

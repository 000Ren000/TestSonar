﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Функция УзелСервисаРаспознаванияДокументов() Экспорт
	
	Возврат ПланыОбмена.ОбменССервисомРаспознаванияДокументов.НайтиПоКоду("001");
	
КонецФункции

Процедура СоздатьУзлыСервисаРаспознаванияДокументов() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ЭтотУзел = ПланыОбмена.ОбменССервисомРаспознаванияДокументов.ЭтотУзел();
	Если Не ЭтотУзел.Пустая() Тогда
		Объект = ЭтотУзел.ПолучитьОбъект();
		Объект.Код = "000";
		Объект.Наименование = НСтр("ru = 'Узел этой информационной базы'", ОбщегоНазначения.КодОсновногоЯзыка());
		Объект.Записать();
	КонецЕсли;
	
	Если УзелСервисаРаспознаванияДокументов().Пустая() Тогда
		Объект = ПланыОбмена.ОбменССервисомРаспознаванияДокументов.СоздатьУзел();
		Объект.Код = "001";
		Объект.Наименование = НСтр("ru = 'Узел сервиса распознавания документов'", ОбщегоНазначения.КодОсновногоЯзыка());
		Объект.Записать();
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

#КонецЕсли